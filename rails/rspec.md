# Rspec

## Configuration
Assuming you have the gem "rspec" in your gemfile, then
```sh
$ bundle install
$ rspec init
```
is probably enough to get started

## Running tests
To run tests for a _project_ always use `bundle exec`, which uses the ruby, and the gems of the current project, rather than the globally installed versions

For Rspec
```sh
$ bundle exec rspec
```

But also for other commands, e.g. rubocop:
```sh
$ bundle exec rubocop
```

```
# To run all the tests
$ bundle exec rspec

# To run the tests in a specific file:
$ bundle exec rspec spec/functions/dynamo_reader_spec.rb

# To run the tests at a specific line number:
$ bundle exec rspec spec/functions/finalise_settlement_spec.rb:177
```