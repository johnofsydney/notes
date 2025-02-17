# Rails Notes

## Helpers

Remove logic from the view, by putting it in a helper.

- The view itself is cleaner and easier to read.
- The logic can be tested in unit tests.

- best not to overload the helper. Keep most of the logic in the controller, model or lib

- A helper is a module which rails will _auto-magically_ include in controllers and views.
- Rails < 4 - helpers are available within controllers / views of the same name.
- Rails > 5 - helpers are availble globally. So be careful.

https://mixandgo.com/learn/the-beginners-guide-to-rails-helpers

## Concerns

Remove code from model file, particularly when it can be used across several different models. It is then _auto-magically_ `included` in the models where required.

## Service Class / Service Object

Another place to put code that doesn't truly belong in either a model or a controller.
If the code can be used across several models / controllers - consider moving it to a service class.
If the controller codebase is getting too long, and it's core functionality (eg CRUD) would be clearer by moving some code elsewhere - consider moving it to a service class.
Each service class should encapsulate a single piece of business logic. Of course you can combine several classes in a module to keep track of things.
https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial
Place your service object in `app/services` Rails will load this object _auto-magically_ because it autoloads everything under app/.

## Rails magic - autoloading

https://guides.rubyonrails.org/autoloading_and_reloading_constants.html

---

## Decorators

Bearing in mind

- Models should be fat and controllers skinny
- Models don't need to know anything about presenting the data, and views should be dumb and just present the data
  It seems we should stack _everything_ into the controller. But
- They might get too big and unwiedly
- Quite likely you'll duplicate presentation logic in different controller methods, both within the same controller and across different controllers
  So an option is to use the design pattern defined by _decorators_

Read up more here: https://www.thegreatcodeadventure.com/rails-refactoring-part-iii-the-decorator-pattern/
TODO: write up a personal description when I have a personal example

---

## Gems

```rb
  # using a gem in the normal fashion
  gem 'foo_bar_models', '~> 0.2.802',
    # then require: 'foo_bar/models'

  # using a gem via git, specifying a branch
  gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
    # then require: 'faker'

  # using a local gem
  gem 'foo_bar_models', path: '../foo_bar-models'
    # then require: 'foo_bar/models',

```

### Updating gems

```bash
$ bundle outdated --filter-patch
<...>
Outdated gems included in the bundle:
  * capistrano (newest 3.11.1, installed 3.11.0, requested ~> 3.1) in groups "development"
$ bundle update capistrano --conservative
<...>
Fetching capistrano 3.11.1 (was 3.11.0)
Installing capistrano 3.11.1 (was 3.11.0)
Bundle updated!
```

## Rubocop

Rubocop project settings are in `.rubocop.yml`

`bundle exec rake rubocop`
`bundle exec rubocop --help`

`spring rake rubocop` - Fast Rubocop
`spring rake rubocop -a` - Rubocop fixes what it can

To make rubocop ignore a particular setting for a particular method, eg:

```rb
  # rubocop:disable Metrics/AbcSize
	def your_method_name
		<code>
	end
  # rubocop:enable Metrics/AbcSize
```

## puma-dev

- great for running lots of rails apps easily.
- doesn't let you 'pry' into the code
- to use `rails s`, first: `puma-dev -stop`
- might need to know `cd ~/.puma-dev/`

## Rake within rails

Rake tasks are automatically loaded from the folder structure lib/tasks/\*.rake

When we are talking about the task db:migrate for example, it is located within the rails gem in lib/tasks/databases.rake

So for a specific project, you will always have the tasks within the project folder structure as well as all tasks within the specified gems.

https://stackoverflow.com/questions/4742930/where-are-rake-tasks-defined

## Scope

ActiveRecord is the default ORM for rails. When we have an ActiveRecord collection, we can invoke methods such as `User.first` or `User.all`

Scopes allow us to specify custom methods to invoke on a collection, e.g.

```
class TokenizedFooBar < ApplicationRecord
  FASTERCARD = 'FasterCard'.freeze

  scope :not_scrubbed, -> { where.not(encrypted_number: nil) }
  scope :expiring_in, -> (range) { where(expiry: range) }
  scope :fastercard, -> { where(card_type: FASTERCARD) }
end
```

which can then be used thusly:

```
TokenizedCreditCard.fastercard.expiring_in(EXPIRY_RANGE).limit(20)
```

note that these can be _chained_ just as any ruby method

## Rails Methods

### create vs create!

_Ruby programmers reserve ! to adorn the names of methods that do something unexpected, or perhaps a bit dangerous_

In this case, the "unexpected" result is that an exception is raised instead of just failing and returning false.
So, if the instance of the class / model / record, cannot be created (e.g. a validation error) then

```
.create
=> false

.create!
=> Raises Exception
```

## Validation

Validations are used to ensure that only valid data is saved into your database. Model-level validations are the best way to ensure that only valid data is saved into your database. They are database agnostic, cannot be bypassed by end users, and are convenient to test and maintain.
The following methods trigger validations, and will save the object to the database only if the object is valid:

- create
- create!
- save
- save!
- update
- update_attributes
- update_attributes!
  The bang versions (e.g. save!) raise an exception if the record is invalid. The non-bang versions don’t: save and update_attributes return false, create and update just return the objects.

The following methods skip validations, and will save the object to the database regardless of its validity. They should be used with caution.

- decrement!
- decrement_counter
- increment!
- increment_counter
- toggle!
- touch
- update_all
- update_attribute
- update_column
- update_counters

# Callbacks

Callbacks are methods that get called at certain moments of an object’s life cycle. With callbacks it is possible to write code that will run whenever an Active Record object is created, saved, updated, deleted, validated, or loaded from the database.

- **Creating an Object**
  - before_validation
  - after_validation
  - before_save
  - around_save
  - before_create
  - around_create
  - after_create
  - after_save
- **Updating an Object**
  - before_validation
  - after_validation
  - before_save
  - around_save
  - before_update
  - around_update
  - after_update
  - after_save
- **Destroying an Object**
  - before_destroy
  - around_destroy
  - after_destroy

### update attributes / columns

`update_attributes` tries to **validate** the record, calls **callbacks** and **saves**;
`update_attribute` doesn't **validate** the record, calls **callbacks** and **saves**;
`update_column` doesn't **validate** the record, doesn't call **callbacks**, doesn't call **save** method, though it does update record in the database.

# Database actions

- dump database
- copy to local
- restore into local database

### Remote

```
$ pg_dump  <DATABASE_NAME> -U <USERNAME> -h localhost > database.bak
```

### Local

```
$ scp deploy@3.27.57.193:~/lester/current/database.bak ~/Desktop/database.bak
$ rails db:drop && rails db:create
$ psql -d sunshine_guardian_development < ~/Desktop/database.bak
```

### cURL example

```
curl -X POST http://localhost:3000/users/sign_in \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-d '{"email": "tom@money.com", "password": "foo"}'
```

## restoring a database backup

Using a fresh new empty database created from Hatchbox

```sh
cd ~/backups/db_63cfd30508ad/2024.10.26.02.12.02/
pg_restore -U user_4bd889468a0a -W -h 127.0.0.01 -d db_923810d8c248 --no-acl --no-owner db_63cfd30508ad.sql
# pg_restore -U <DB_USER> -W -h 127.0.0.01 -d < DB_NAME > --no-acl --no-owner path/to/backup_file.sql.or.bak
cd ~/lester/current
rails db:migrate
exit
```

And then, in Hatchbox, _attach_ this new database to the application
