# Ruby

## Struct
- Like a lightweight class. You can make new instances of a type of Struct
- has a predefined set of attributes. You can't arbitrarily add more later.
- _values_ for the attributes are set when you define the _instance_ of the Struct.
- you can define and invoke a method for a Struct


## OpenStruct
- not like a class, in that you can't make new instances of an OpenStruct. A variable of type OpenStruct is a bit like an instance of a class
- accepts zero or one argument, a hash which then sets the attribute _and_ the value
- can add attributes later as required
- You can define a method for an OpenStruct, but it doesn't seem able to be invoked.
- It isn't as fast as Struct, but it is more flexible.


### Example
```ruby
Person = Struct.new(:name, :age)
=> Person

john = Person.new
=> #<struct Person name=nil, age=nil>
john.name = "john"
=> "john"
john.age = 100
=> 100
john
=> #<struct Person name="john", age=100>


john.height = 182
NoMethodError: undefined method `height=' for #<struct Person name="john", age=100>
from (pry):8:in `__pry__'


Dog = OpenStruct.new(:name, :age)
ArgumentError: wrong number of arguments (given 2, expected 0..1)
from /Users/john.coote/.rbenv/versions/2.6.2/lib/ruby/2.6.0/ostruct.rb:91:in `initialize'

Dog = OpenStruct.new(name: 'fido')
=> #<OpenStruct name="fido">

fido = Dog.new
=> nil
fido
=> nil

Dog.name
=> "fido"
Dog.age = 7
=> 7
[20] pry(main)> Dog
=> #<OpenStruct name="fido", age=7>


Cat = Struct.new(:name, :age, :owner) do
  def print_details
    "#{name} is a cat of #{age} years old. Their owner is #{owner}"
  end
end
=> Cat

pet_cat = Cat.new("mr. tibs", 3, "john")
=> #<struct Cat name="mr. tibs", age=3, owner="john">
pet_cat.print_details
=> "mr. tibs is a cat of 3 years old. Their owner is john"

other_cat = Cat.new("mr. tibs", 3, john)
=> #<struct Cat name="mr. tibs", age=3, owner=#<struct Person name="john", age=100>>
other_cat.print_details
=> "mr. tibs is a cat of 3 years old. Their owner is #<struct Person name=\"john\", age=100>"

```

https://www.leighhalliday.com/ruby-struct

