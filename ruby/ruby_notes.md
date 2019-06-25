# Ruby Notes



## Modules
Are a bit like classes, but a bit different too
A Module can contain constants and methods and these can be called directly on the Module, like a class method eg
```
module Foo
  def self.hello
    puts "hello"
  end
end

Foo.hello
# => "hello"
```
But you can't make a new instace of a module. After all it's not a class.

Module's are a useful way of moving code out of a class though, you write the code in the module, and then include it with the class.
All code that is included in this way acts as if it were written directly in the class.
```
module Foo
  def say_foo
    p "foo"
  end  
end  

class Bar
  include Foo
end  

bar = Bar.new
bar.say_foo
"foo"
=> "foo"
```
If your module is in another file (and can't be accessed via rails magic) then you need to `require` the file and `include` the module in your class.



## Class methods
Called on the _class_ rather than the instance of the class.
```
class Person
  def self.name
    "Matz"
  end
end
```
`name` is a class method, you'd call it thusly - `Person.name` _=> "Matz"_

The same result can be acheived as follows:
```
class Person
  class << self
    def name
      "Matz"
    end
  end
end
```
different styles according to the situation. There's also other different ways to do the same thing.
https://yehudakatz.com/2009/11/15/metaprogramming-in-ruby-its-all-about-the-self/
https://dev.to/adamlombard/ruby-class-methods-vs-instance-methods-4aje

https://stackoverflow.com/questions/2505067/class-self-idiom-in-ruby
```
class Foo  
  def an_instance_method  
    puts "I am an instance method"  
  end  
  def self.a_class_method  
    puts "I am a class method"  
  end  
end

foo = Foo.new

def foo.a_singleton_method
  puts "I am a singletone method"
end
```


## Rake
Is a domain specific language that can be run from the command line, such as
`rake db:migrate`
`rake` obvs invokes rake
`db` is the _namespace_ - a container for related _tasks_ 
`migrate` is the _task_
the namespace and the task are defined in the `.rake` file(s) _in the `lib` folder of your rails project if applicable_

`Rake` is like unix `make` _but_ with the very handy fact that the `r` is for ruby.
The _task_ itself is written in ruby, e.g.
```
task :play do
  puts "Here's a rake task!"
end
```
With the very handy result that you can invoke a rake task, which then runs a bunch of ruby code, which can access any part of your rails project

#### Rake task
```
namespace :whatevs do
  desc "Update names"

  task update_names: do
    Whatevs::UpdateNames.run
  end
end
```

#### Ruby code invoked by rake...
```
module Whatevs
  module UpdateNames
    class << self
      def run
        affected_peeps = Person.where(name: %w[tom dick harry])

        affected_peeps.each do |peep|
          peep.upcase
          peep.save
        end
      end
    end
  end
end
```
So, rake as per the example above is great for one off tasks that require all the power of ruby / rails.
https://medium.com/craft-academy/what-the-heck-is-rake-b44d4210922b
https://www.stuartellis.name/articles/rake/

(see also rails_notes.md)

