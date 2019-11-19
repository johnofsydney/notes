# Ruby

## Cool / Unusual Exotic / Methods

#### `tap`
_The primary purpose of this method is to “tap into” a method chain, in order to perform operations on intermediate results within the chain._  
[https://apidock.com/ruby/Object/tap](https://apidock.com/ruby/Object/tap)

```
(1..10).to_a.select{|x| x.odd?}.tap{ |x| p x * 2 }
[1, 3, 5, 7, 9, 1, 3, 5, 7, 9]
=> [1, 3, 5, 7, 9]
(1..10).to_a.select{|x| x.odd?}.tap{ |x| x * 2 }
=> [1, 3, 5, 7, 9]
```

**ex 1 above** - the _return_ value is the odd values of the array, and the _tap_ method performs an operation on that array (_x_) which is to print it twice.  
**ex 2 above** - the _return_ value is the odd values of the array, but the _tap_ method is not actually performing any operation on that array (_x_).

**ex 3 below** - the _tap_ method is printing out the intermediate value of the array at two points in the chain. As there is a final `select` after the last _tap_ the return value is not the same as the last tap output.  
```
(1..10).to_a.select{|x| x.odd?}.tap{ |x| p x * 2 }.select{|x| x > 4 }.tap{|x| p x * 2}.select{|x| x < 6}
[1, 3, 5, 7, 9, 1, 3, 5, 7, 9]
[5, 7, 9, 5, 7, 9]
=> [5]
```

#### `.each_with_index` _and_ `.map.with_index`
OK, so not that exotic, but haven't used it much.

```
arr
=> ["an", "array", "of", "words"]
```

```
##### .each_with_index
arr
  .each_with_index{ |x, i| p "prints both element #{x} and index #{i}" }

"prints both element an and index 0"
"prints both element array and index 1"
"prints both element of and index 2"
"prints both element words and index 3"

=> ["an", "array", "of", "words"]
```

###### .map.with_index
```
arr
  .map
  .with_index{ |e, i| "MAPS both element #{e} and index #{i}" }
=> ["MAPS both element an and index 0",
 "MAPS both element array and index 1",
 "MAPS both element of and index 2",
 "MAPS both element words and index 3"]
```

##### .with_object
```
arr
  .map
  .with_object({}){ |element, object| object[element.to_sym] = element }
=> {
      :an=>"an", 
      :array=>"array", 
      :of=>"of", 
      :words=>"words"
    }

arr
  .map
  .with_object({:pre => "existing", :keys => "and values"}){ |element, object| object[element.to_sym] = element }
=> {
      :pre=>"existing", 
      :keys=>"and values", 
      :an=>"an", 
      :array=>"array", 
      :of=>"of", 
      :words=>"words"
    }

arr
  .each_with_index
  .map
  .with_object({}){ |(element, index), object| object[element.to_sym] = index }
=> {
      :an=>0, 
      :array=>1, 
      :of=>2, 
      :words=>3
    }
```


## Yield

Basically allows you to pass around a code block to be run inside other methods.
In the example below the _code block_  is as usual, the bit inside the `{}` curlies.


```ruby
def time_an_action
  start_time = Time.now

  yield

  end_time = Time.now

  return end_time - start_time
end


def some_consumer
  time_it_took = time_an_action { Database.retrieve }
end
```

So, above, when we invoke `some_consumer` it will call `time_an_action` and pass in the block `Database.retrieve`, but you could pass in different code blocks and time them, while keeping the same wrapper code around.

_Yield_ has no effect on parameters that are passed in to the method in the normal way. We could call
```ruby
  time_an_action(argument) {Database.retrieve}
```

And it's possible to pass in paramaters to the block, but that's for another day.

_When you are driving, if you see the yield sign, you let other vehicles pass through before you enter the road. In Ruby, the yield keyword yields the flow of control to the code in the block. So, the code in the block is executed and the execution continues after the line containing the yield._

https://rubyplus.com/articles/4801-Ruby-Basics-The-yield-Keyword
https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/18-blocks/lessons/54-yield



### Internationalization Things

If you need to replace accented chars like `ä` with their plainer versions (`a`) then do this...
```rb
require "i18n"

# replace accented characters with plain versions
I18n.available_locales = I18n.available_locales + [:en]
text = I18n.transliterate(text)
```




### Shovel operator

#### Here's he Shovel Operator working in standard uncomplicated fashion:
```
[1,2,3] << 5
=> [1, 2, 3, 5]
```

#### But what is going on here?
```rb
# define a hash
h = {breed: 'Dog', name: 'Rex'}
=> {:breed=>"Dog", :name=>"Rex"}

# shovel that hash into an unamed class with a method
class << h
  def greet
    p "I am #{self[:name]}, a #{self[:breed]}"
  end
end
=> :greet

# hash pretends to be untouched
> h
=> {:breed=>"Dog", :name=>"Rex"}
> h.class
=> Hash

# We can call the method
h.greet
"I am Rex, a Dog"
=> "I am Rex, a Dog"
```