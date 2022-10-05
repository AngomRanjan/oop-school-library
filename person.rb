require './nameable'

class Person < Nameable
  # getter
  attr_reader :id, :rentals

  # getter cum setter
  attr_accessor :name, :age

  def initialize(age, name = 'Unknown', parent_permission: true)
    super()
    @id = Random.rand(1..50)
    @age = age
    @name = name
    @parent_permission = parent_permission
    @rentals = []
  end

  def can_use_services
    if of_age? || parent_permission
      true
    else
      false
    end
  end

  def correct_name
    @name
  end

  def add_rental(rental, date)
    @rentals.push(rental)
    rentals.person = self
    rentals.date = date
  end

  private

  def of_age?
    @age > 18
  end
end
