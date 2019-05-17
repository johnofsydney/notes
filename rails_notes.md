# Rails Notes

## RSpec
---

### build vs create

The create() method persists the instance of the model while the build()method keeps it only on memory.
Personally, I use the create() method only when persistence is really necessary since writing to DB makes testing time consuming.
e.g.
I create users to authentication with create() because my authentication engine queries the DB.
To check if a model has an attribute the build() method will do because no DB access is required.

---

Using FactoryGirl.build(:factory_name) does not persist to the db and does not call save!, so your Active Record validations will not run. This is much faster, but validations might be important.
Using FactoryGirl.create(:factory_name) will persist to the db and will call Active Record validations. This is obviously slower but can catch validation errors (if you care about them in your tests).

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