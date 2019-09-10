# Ruby

## gems

### bundler

bundler is a ruby gem. For mananging dependencies.

bundler generates the Gemfile.lock, from either the Gemfile or the gemspec

strange things might happen if you sue the wrong version of bundler.
as with other gems, there's a version(s) of bundler for each ruby version.

`$ bundler --version`
to find out bundler version _for the ruby version of the project_

`$ gem uninstall bundler`
to _globally_ uninstall bundler for the current ruby version

```
$ gem install bundler -v 1.17.3
# install a specific version

$ bundler --version
Bundler version 1.17.3
```
