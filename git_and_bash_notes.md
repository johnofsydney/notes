# Git and Bash Notes

## Git Diff
to manually git diff, eg -
`git diff -C -M <LATEST COMMIT ID> <EARLIER COMMIT ID> -- "package-lock.json"`


## Git config
`git config --global core.editor "code --wait"`
`git config --global -e`


## reverting a file
```
$ git checkout -- Gemfile.lock
# will unstage a file that has been modified

$ git checkout master -- Gemfile.lock
# will get a file from a different branch

```

## _partially_ adding to staging
```
$ git add -p
# will step through a file that needs to be staged, hunk by hunk, so you can choose only the psrtd you want to add and then commit.
```

## Renaming branches
```
$ git branch -m old-name new-name
# will rename local branch from old-name to new-name

$ git branch -a
# to confirm

$ git push origin :old-name new-name
# will delete the remoe version of old-name and push the branch with new-name
```

## Delete branch
```
$ git branch -d branch_name
# safely delete a local branch that has been pushed and merged
```

## cURL

### Testing an API using cURL

- Make a test.json file, eg -

```js
{
  "name": "TEST HOOK1",
  "address": "https://www.your-server.com/foo/bar",
  "authentication_username": null,
  "authentication_password": null,
  "mode": "Production",
  "events": "foo,bar,bundy",
  "is_active": true
}
```

Then send a `cURL` command thusly:
`curl https://server.co/v1.0/path -d @test.json -u TEST:TEST`
Where
`-d` tells it we’re sending data (like a form post)
`@` tells it we’re using data from a file, not the command line
`-u` tells it we’re sending `username:password`, in this case `TEST:TEST`
