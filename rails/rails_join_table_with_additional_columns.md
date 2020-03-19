# Rails Project - join table with extra column(s)

If you need to join two tables, e.g. students & courses, or patients & doctors, but also store extra information relating to the join itself, read on.
In the case of joining patients and doctors, we could call the join `appointments`, it would have additional information relating to the appointment time, and this is the example used in the [rails guides](https://guides.rubyonrails.org/association_basics.html#the-has-many-through-association)
In the case of joining students and classes, we could call the join `results`, and it would have additional information about the score that a particular student got for a particular course.

It's this `result => student / course / score` combination described here in this note:

[project repo](https://github.com/johnofsydney/results_join_table)

check in the repo as a reference for anything not listed here. Otherwise just follow the steps below to get the project up and running.

### First set up the project and generate resources
Run these from a fresh teminal window
```sh
$ rails new results_join_table -T -d postgresql
$ cd results_join_table
$ rails db:create
$ rails g resource Student name:string
$ rails g resource Course title:string
$ rails g resource Result score:integer
```

Your other two migrations shoule be fine, adjust this one to suit. (adding in the student and course relationships)
(check migration files in the folder `db/migrate` )
```rb
class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.belongs_to :student
      t.belongs_to :course
      t.integer :score

      t.timestamps
    end
  end
end
```

### Run database migrations and start Rails console
And back to terminal
```sh
$ rails db:migrate
$ rails c
```

### Add a few students and courses
And then in Rails console
```rb
tom = Student.create(name: "tom")
dick = Student.create(name: "dick")
harry = Student.create(name: "harry")
sally = Student.create(name: "sally")
daisy = Student.create(name: "daisy")
jessy = Student.create(name: "jessy")
beccy = Student.create(name: "beccy")
wdi = Course.create(title: "WDI")
sei = Course.create(title: "SEI")
```

Still in Rails console, note three ways of creating a record
```rb
r = Result.new
r.student = tom
r.course = wdi
r.score = 1
r.save

r2 = Result.new(student: sally, course: sei, score: 2)
r2.save

r3 = Result.create(student: daisy, course: sei, score: 3)

Result.create(student: jessy, course: sei, score: 4)
Result.create(student: beccy, course: sei, score: 5)

Result.create(student: dick, course: wdi, score: 6
Result.create(student: harry, course: wdi, score: 7)

# let beccy and dick enrol in both courses
Result.create(student: beccy, course: wdi, score: 8)
Result.create(student: dick, course: sei, score: 9)

Result.count 
=> 9

wdi.students.count 
=> 4
sei.students.count 
=> 5
dick.courses.count 
=> 2
jessy.courses.count 
=> 1

Course.last.students.map{ |r| r.name } 
=> ["sally", "daisy", "jessy", "beccy", "dick"]
sei.results.map{ |r| {name: r.student.name, score: r.score } } 
=> [{:name=>"sally", :score=>2}, {:name=>"daisy", :score=>3}, {:name=>"jessy", :score=>4}, {:name=>"beccy", :score=>5}, {:name=>"dick", :score=>9}]

```

Here we have finished setting up a db with 3 models, one of which is a join table with an additional column.
Look in `db/schema.rb` - always the source of truth for what's real in the database