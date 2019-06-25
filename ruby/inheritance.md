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