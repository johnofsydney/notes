# Ruby
## procs, blocks and lambdas

```
a = [1,2,3,4,5]
```

### BLOCKS
a block is the bit of code between the {}, which could be written alternatively between `do` and `end`
```
b = a.map { |x| x ** 2 }
```

### PROCS
a proc is basically a code snippet, which can be reused eg
```
p = Proc.new { |x| x ** 2 }
c = b.map(&p)
```

A PROC can be called directly, by `proc_name.call` _though the example above can't really as it acts on an array and not on nothing at all._ But we can do

```
p1 = Proc.new { puts c }
p1.call
```

### Lambdas
A lambda is also a code snippet, but declared slightly differently, thus:
```
l = lambda { |x| x ** 2 }
d = b.map(&l)
```

and can also be called thusly
```
l1 = lambda { puts d }
l1.call
```

also _stabby_ lambdas
```
foo = ->(arg1,arg2) {arg1 * arg2}
=> #<Proc:0x00007fe442a058b0@(pry):2 (lambda)>

foo.call(2, 3)
=> 6

[5] pry(main)> foo.call("foo", 3)
=> "foofoofoo"
```
--

The block of code can't be assigned directly to a variable. eg
```
var = { |x| x ** 2 } 
==> nope
```

to pass it around as a variable / object and re-use it later you have to make it a proc or lambda eg
```
var1 = Proc.new { |x| x** 2 }
#  or
var2 = lambda { |x| x ** 2 }
```



There are differences between procs and lambdas...
A lambda is a type of proc, one that ensures the number of parameters passed to it is correct.
from https://stackoverflow.com/questions/8476627/what-do-you-call-the-operator-in-ruby

```
[5] pry(main)> l = lambda { |x| x ** 2 }
=> #<Proc:0x00007fc04d797ec0@(pry):5 (lambda)>
[6] pry(main)> l.call(4)
=> 16
[7] pry(main)> l.call(4,5)
ArgumentError: wrong number of arguments (given 2, expected 1)

[8] pry(main)> p = Proc.new {|x| x**2 }
=> #<Proc:0x00007fc04d72cbc0@(pry):8>
[9] pry(main)> p.call(4)
=> 16
[10] pry(main)> p.call(4,5)
=> 16
```