#!/usr/bin/env bash

# EXIT STATUS
#      The grep utility exits with one of the following values:

#      0     One or more lines were selected.
#      1     No lines were selected.
#      >1    An error occurred.


# If no files can be found with grep we should exit here.
# otherwise the pipe will fail, but rubocop will show no errors because it will have no input
{
  git diff --name-status origin/master | grep -v "^D\|^R"
  GREP_RESULT_1="$?"
} &> /dev/null


if [ "$GREP_RESULT_1" -ne 0 ]; then
  echo "No Modified files found"
  exit 0
fi


# If no files can be found with grep we should exit here.
# otherwise the pipe will fail, but rubocop will show no errors because it will have no input
{
  git diff --name-status origin/master | grep -v "^D\|^R" | grep -v ".erb$" | grep ".rb"
  GREP_RESULT_2="$?"
} &> /dev/null

if [ "$GREP_RESULT_2" -ne 0 ]; then
  echo "No Modified ruby files found"
  exit 0
fi

{
  git diff --name-status origin/master | grep -v "^D\|^R" | grep -v ".erb$" | grep ".rb" | awk '{print $2}'
  AWKRESULTS="$?"
} &> /dev/null

if [ "$AWKRESULTS" -ne 0 ]; then
  echo "Nothing to awk"
  exit 0
fi

# If the first rubocop step finds no offenses, then exit here
{
  git diff --name-status origin/master | grep -v "^D\|^R" | grep -v ".erb$" | grep ".rb"| awk '{print $2}' | xargs bundle exec rubocop --force-exclusion
  RESULT="$?"
  echo "$RESULT"
} &> /dev/null

if [ "$RESULT" -eq 0 ]; then
  echo "No Rubocop offenses"
  exit 0
fi

# If there are rubocop offenses, cat them and exit 1
git diff --name-status origin/master | grep -v "^D\|^R" | grep -v ".erb$" | grep ".rb" | awk '{print $2}' | xargs bundle exec rubocop --force-exclusion | cat

exit 1
