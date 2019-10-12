# Rails Notes

## Helpers 
Remove logic from the view, by putting it in a helper.
- The view itself is cleaner and easier to read.
- The logic can be tested in unit tests.

- best not to overload the helper. Keep most of the logic in the controller, model or lib

- A helper is a module which rails will *auto-magically* include in controllers and views. 
- Rails < 4 - helpers are available within controllers / views of the same name.
- Rails > 5 - helpers are availble globally. So be careful.

https://mixandgo.com/learn/the-beginners-guide-to-rails-helpers  

## Concerns 
Remove code from model file, particularly when it can be used across several different models. It is then *auto-magically* `included` in the models where required.

## Service Class / Service Object
Another place to put code that doesn't truly belong in either a model or a controller. 
If the code can be used across several models / controllers - consider moving it to a service class.
If the controller codebase is getting too long, and it's core functionality (eg CRUD) would be clearer by moving some code elsewhere - consider moving it to a service class.
Each service class should encapsulate a single piece of business logic. Of course you can combine several classes in a module to keep track of things.
https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial
Place your service object in `app/services` Rails will load this object *auto-magically* because it autoloads everything under app/. 


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
  # gem 'foo_bar_models', '~> 0.2.802', require: 'foo_bar/models'

  # using a gem via git, specifying a branch
  # gem 'foo_bar_models', require: 'foo_bar/models', git: gem_stash_url('foo_bar-models'), branch: 'bug/whatever'

  # using a local gem
  gem 'foo_bar_models',
    require: 'foo_bar/models',
    path: '../foo_bar-models'
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
Rake tasks are automatically loaded from the folder structure lib/tasks/*.rake

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

