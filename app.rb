require './student'
require './teacher'
require './book'
require './rental'
require 'io/console'

class App
  def initialize
    @books = []
    @persons = []
    @rentals = []
  end

  def back_to_main_menu
    print "\n\nPress any key to return to main menu...."
    $stdin.getch
  end

  def choice_bool(test = '', str = '', type = 'i')
    print "\n", str, "\nPress any key to return to main menu ..."
    if type == 'i'
      test.include? $stdin.getch.to_i
    else
      test.include? $stdin.getch
    end
  end

  def list_all_books
    if @books.empty?
      puts 'Book List is empty!'
    else
      @books.each { |book| puts "Title: '#{book.title}', Author: #{book.author}" }
    end
    back_to_main_menu
  end

  def list_all_persons
    if @persons.empty?
      puts 'Person List is empty!'
    else
      @persons.each { |person| puts "[#{person.class}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}" }
    end
    back_to_main_menu
  end

  def person_type
    opt = 0
    mid_str = "\nEnter Your choice: "
    loop do
      system('clear')
      print "\nCreate a Person\n"
      print "\nEnter 1 to create Student\nEnter 2 to create Teacher", mid_str
      break if (1..2).include?(opt = gets.chomp.to_i)

      mid_str = "\n Invalid Type! Please Enter 1 or 2: "
    end
    opt
  end

  def name_title(str)
    item_valid = false
    msg = "\nPlease Enter #{str}:  "
    until item_valid
      print "\n", msg
      item_valid = (name_str = gets.chomp).length.positive?
      msg = "Invalid Input! #{str} cannot be empty\nPlease Enter Again: "
    end
    name_str
  end

  def age_entry
    item_valid = false
    until item_valid
      print 'Enter Age: '
      item_valid = (1..100).include?(age = gets.chomp.to_i)
      print 'Enter a valid age between 1 to 100' unless item_valid
    end
    age
  end

  def create_student
    name = name_title('name')
    age = age_entry
    item_valid = false
    until item_valid
      print 'Whether have parent permission [Y/N]: '
      item_valid = %w[Y y N n].include?(permission = $stdin.getch)
      puts
    end
    permission = permission.capitalize == 'Y'
    stud = Student.new(age, name, parent_permission: permission)
    @persons << stud
    print "\n\nID: #{stud.id} Name: #{stud.name} Age: #{stud.age} Parent Permission: #{stud.parent_permission}"
    print "\nNew Student is created successfuly\n"
  end

  def create_teacher
    name = name_title('name')
    age = age_entry
    specialization = name_title('specialization')
    $stdin.getch
    teacher = Teacher.new(age, specialization, name)
    @persons << teacher
    print "\n\nName: #{teacher.name} Age: #{teacher.age}"
    print "\nNew Teacher is created successfuly\n"
  end

  def create_a_person
    add_item = true
    while add_item
      if person_type == 1
        create_student
      else
        create_teacher
      end
      add_item = choice_bool(%w[Y y], "Press [Y/y] to add another person\nOr", 's')
    end
  end

  def create_a_book
    print 'create a book'
    puts 'Press Enter to continue ...'
    $stdin.getc
  end

  def create_a_rental
    print 'create a rental'
    puts 'Press Enter to continue ...'
    $stdin.getc
  end

  def list_all_rentals
    print "\nlist all rental"
    print "\nPress Enter to continue ..."
    $stdin.getc
  end

  def exit_app
    system('clear')
    print "\n" * 3, "\t" * 3, '|| ', '=' * 8, ' Thanks For Using OOP School Library Application ',
          '=' * 8, ' ||', "\n" * 3
    exit
  end

  def app_run(func)
    system('clear')
    method(func).call
    "\nEnter your choice (1 - 7): "
  end
end
