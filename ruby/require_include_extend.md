# Ruby

## Require / Include / Extend

### Require
Is used to import a library (separate file)
Once a file is _required_ in your project you can use the code as if it were written in your project.
- to use a gem - require it
- in a test file, require the file under test.

### Include 
The include method is the primary way to "extend" classes with other modules (usually referred to as mix-ins). (from SO)
If you `include` a module in your class, all of the methods etc defined in the module are now available in the class, as if they were a native part of the class.
The methods thusly defined are _instance variables_
good discussion: https://stackoverflow.com/questions/318144/what-is-the-difference-between-include-and-require-in-ruby

### Extend
Like _include_ but different. the standard methods in the module with which you extend your class become class methods.


#### Further note on include vs extend
thinking about the direction
If your class _includes_ a module, the class is the primary thing. A class has instances, thus the standard  methods in the module are now instance methods.
If your class _extends_ a module, the module is the primary thing. A module has no intances, the the standard methods in the module are class methods.


TODO - tidy up below...
```
require "pry"

# Include and Extend
# examples of how to include a module in various classes.

# The methods in the module below then are available to the instances of the classes in which they are included.
module Electricity
  def power
    "The power of the sun in the palm of my hand"
  end

  def shock
    "It's only a tickle"
  end

end

class Guitar
  include Electricity
end

class Car
  include Electricity
end

class Person
  include Electricity
end

stratocaster = Guitar.new
tesla = Car.new
john = Person.new

p stratocaster.power
p tesla.power
p john.shock


# Using extend we can add the methods in the module as class methods,
# as in the ridiculous examples below

class Array
  extend Electricity
end
class Integer
  extend Electricity
end

p Array.shock
p Integer.power



binding.pry
```