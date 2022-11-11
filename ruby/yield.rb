require 'pry'
require 'rails'



class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def work(hours, rate)
    penalty = block_given? ? yield : 1

    {
      name: name,
      hours: hours,
      dollars: hours * rate * penalty.to_f
    }
  end

  def commute(distance, weather)

    means = yield(weather)

    speed = case means
    when 'scooter'
      20
    when 'train'
      30
    when 'car'
      30
    end

    rate = case means
    when 'scooter'
      20
    when 'train'
      30
    when 'car'
      50
    end

    {
      minutes: to_minutes(distance.to_f / speed),
      cost: distance.to_f * rate / 100
    }
  end

  def self.check
    'condition'.present?
  end

  def to_minutes(hours)
    (hours * 60).round
  end
end


john = Person.new('john', 25)
phil = Person.new('phil', 24)

john_wages_monday = john.work(8, 50)

# this method is used inside a block. It must be defined above the block in order for the block to know about it
# def check
#   'condition'.present?
# end


john_wages_sunday = john.work(8, 50) do
  if Person.check
    1.5
  else
    1.25
  end
end



phil_wages = phil.work(8, 50) { 'a pretend conditional thing'.present? ? 2 : 3}


john_commute = john.commute(5, 'sunny') do |weather|
  if weather == 'rain'
    'train'
  else
    'scooter'
  end
end

phil_commute = phil.commute(25, 'rain') do  |weather|
  if weather == 'rain'
    'car'
  else
    'train'
  end
end

p john_wages_monday
p john_wages_sunday
p phil_wages

p john_commute
p phil_commute