# Ruby

## Methods

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