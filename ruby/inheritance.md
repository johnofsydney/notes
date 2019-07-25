TODO - tidy up below...

```
require 'pry'
# Example of inheritance


class Boat
  # in this example, Boat is the superclass

  def initialize name
    # Each boat needs a name, which will vary for each instance of the children classes.
    @name = name
  end

  # several methods will be common across all instances and types of Boat
  def captains
    1
  end

  def port
    "left"
  end

  def starboard
    "right"
  end

  # this is a class method it can be called by any of
  # Boat.anchor / Battleship.anchor or Carrier.anchor
  def self.anchor
    "stop"
  end

end

class Battleship < Boat
  # all instances of Battleship inherit the characteristics of Boat as well as their own methods and variables
  def initialize name, guns
    super name
    # calling super from a child invokes the method of the same name in the parent
    # in this case returning @name
    @guns = guns
  end

  def name
    @name
  end

  def guns
    @guns
  end

end

class Carrier < Boat
  # all instances of Carrier inherit the characteristics of Boat as well as their own methods and variables
  def initialize name, helicopters
    super name
    @helicopters = helicopters
  end

  def name
    @name
  end

  def helicopters
    @helicopters
  end

end

victory = Battleship.new "Victory", 104
p victory.name
p victory.captains
p victory.port
p victory.guns

canberra = Carrier.new  "Canberra", 6
p canberra.name
p canberra.captains
p canberra.starboard
p canberra.helicopters

binding.pry
```

## super

Super is a _special_ method, which is called by a class (child) which inherits from another class (parent).
Calling `super` from inside the child will invoke the class method of the parent.

```
class Parent
  def hello
    "return value is a string - hello"
  end
end
=> :hello
Parent.new.hello
=> "return value is a string - hello"

class Child < Parent
  def hello
    super
  end
end
=> :hello
Child.new.hello
=> "return value is a string - hello"
```

more practically, you would use super in the right order and in conjunction with other commands to set values etc in the child - we'll take some of the values from the parent, and over-ride some others e.g.

To consider a practical example, in the `application_controller.rb`, we have a  a method `set_breadcrumbs` which is invoked as one of the `before_filter` actions.

```
class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :set_breadcrumbs

  def set_breadcrumbs
    ariane.add "Home", root_path
  end

```

And then in the `foobars_controller.rb`

```
class FoobarsController < ApplicationController

  def set_breadcrumbs
    super
    ariane.add('Foobars', foobars_path)
    ariane.add(foobar.fat_id, foobar)
  end
end
```


further reading: https://stackoverflow.com/questions/4632224/super-keyword-in-ruby
