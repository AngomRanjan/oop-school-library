require './student'
require './teacher'
require './book'
require './rental'
require 'io/console'
require_relative 'main_menu'

class App
  include MainMenu

  def initialize
    @books = []
    @persons = []
    @rentals = []
  end

  def back_mm(msg = '')
    print "\n\n", msg, "\nPress any key to return to main menu...."
    return yield if block_given?

    $stdin.getch
  end

  def list_item(item, &)
    unless item.empty?
      item.each(&)
      return true
    end
    print "\nNo Record Found! Please try entering some!\n"
    false
  end

  def list_all_books
    print "\n====== List of Books available =======\n\n"
    list_item(@books) { |book| puts "Title: '#{book.title}', Author: #{book.author}" }
    back_mm
  end

  def list_all_persons
    print "\n====== List of Persons =======\n\n"
    list_item(@persons) { |person| puts "[#{person.class}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}" }
    back_mm
  end

  def validate(str, inv_msg, msg = "\nPlease Enter #{str}: ", item_data = nil, isvalid: false)
    until isvalid
      print str == 'person type' ? "#{msg}1 for student and 2 for teacher: " : msg
      item_data = yield item_data
      msg = "\nInvalid #{str}! #{inv_msg} Please Enter Again: " unless (isvalid = !item_data.nil?)
    end
    item_data
  end

  def create_student
    name = validate('name', 'Name cannot be empty!') { |n| n if (n = gets.chomp).length.positive? }
    age = validate('age', 'enter a value between 1 to 100.') { |n| n if (1..100).include?(n = gets.chomp.to_i) }
    permission = validate('Parent Permission', 'press [Y/N]', "\nWhether Have Parent Permission? ") do |n|
      n if %w[Y y N n].include?(n = $stdin.getch)
    end
    permission = (permission.capitalize == 'Y')
    stud = Student.new(age, name, parent_permission: permission)
    @persons << stud
    print "\n\nID: #{stud.id} Name: #{stud.name} Age: #{stud.age} Parent Permission: #{stud.parent_permission}"
    print "\nNew Student is created successfully!\n"
  end

  def create_teacher
    name = validate('name', 'Name cannot be empty!') { |n| n if (n = gets.chomp).length.positive? }
    age = validate('age', 'enter a value between 1 to 100.') { |n| n if (1..100).include?(n = gets.chomp.to_i) }
    specialization = validate('specialization', 'Specialization cannot be empty!') do |n|
      if (n = gets.chomp).length.positive?
        n
      end
    end
    teacher = Teacher.new(age, specialization, name)
    @persons << teacher
    print "\n\nID: #{teacher.id} Name: #{teacher.name} Age: #{teacher.age}"
    print "\nNew Teacher is created successfully!\n"
  end

  def create_a_person
    add_item = true
    while add_item
      system('clear')
      print "\n\t=====\tCreate A Person\t=====\n"
      person_type = validate('person type', 'enter 1 or 2') { |n| n if (1..2).include?(n = gets.chomp.to_i) }
      if person_type == 1
        create_student
      else
        create_teacher
      end
      add_item = back_mm("Press [Y/y] to add another person\nOr") { %w[Y y].include?($stdin.getch) }
    end
  end

  def create_a_book
    add_item = true
    while add_item
      system('clear')
      print "\nCreate a book\n"
      title = validate('title', 'Title cannot be empty') { |n| n if (n = gets.chomp).length.positive? }
      author = validate('author', 'Author cannot be empty') { |n| n if (n = gets.chomp).length.positive? }
      book = Book.new(title, author)
      @books << book
      print "\n\nTitle: #{book.title} Author: #{book.author}"
      print "\nNew Book is created successfully!\n"
      add_item = back_mm("Press [Y/y] to add another book\nOr") { %w[Y y].include?($stdin.getch) }
    end
  end

  def sel_item_by_no(item_name, item_length, sel_mode: false)
    until sel_mode
      print "\nCreate Rental Record\n\nSelect a #{item_name} from the following list by number\n"
      if item_name == 'book'
        list_item(@books) do |book|
          puts "#{@books.find_index(book) + 1} - Title: '#{book.title}', Author: #{book.author}"
        end
      else
        list_item(@persons) do |person|
          puts "#{@persons.find_index(person) + 1} - Name: '#{person.name}', Age: #{person.age}"
        end
      end
      print "\nEnter your choice: "
      sel_mode = (1..item_length).include?(opt = gets.chomp.to_i)
      system('clear')
      print "\nInvalid Input! Please enter a value between 1 to #{item_length}\n" unless sel_mode
    end
    opt - 1
  end

  def create_a_rental
    back_mm("\nBook/Person record is empty! try add some\n\n") unless (add_item = !(@books.empty? || @persons.empty?))
    while add_item
      sel_book = @books[sel_item_by_no('book', @books.length)]
      sel_person = @persons[sel_item_by_no('person', @persons.length)]
      print "\nCreate Rental\n\nEnter a date [format yyyy/mm/dd]: "
      date = gets.chomp
      @rentals << Rental.new(date, sel_person, sel_book)
      print "\nDate: #{date} Book: #{sel_book.title} Name: #{sel_person.name}"
      print "\nNew Rentals Added Successfully!\n"
      add_item = back_mm("Press [Y/y] to add another rental\nOr") { %w[Y y].include?($stdin.getch) }
    end
  end

  def item_by_id(selper: false)
    until selper
      system('clear')
      print "\n====== List of Persons On Rental List =======\n\n"
      @rentals.each { |rental| puts "Name: #{rental.person.name}, ID: #{rental.person.id}" }
      print 'Enter an ID from the list : '
      id = gets.chomp.to_i
      @rentals.each { |rental| selper = true if rental.person.id == id }
    end
    @persons.find { |person| person.id == id }
  end

  def list_all_rentals
    nam1 = item_by_id
    puts "\nList of books rented to ID: #{nam1.id} Name: #{nam1.name}\n\n"
    sel_list = @rentals.select { |rental| rental.person.id == nam1.id }
    sel_list.each { |rental| puts "Date: #{rental.date}. Book: '#{rental.book.title}' Author: #{rental.book.author}" }
    back_mm
  end

  def exit_app
    system('clear')
    print "\n\n\n\t\t\t", '|| ', '=' * 8, ' Thanks For Using Library Application ', '=' * 8, ' ||', "\n\n\n"
    exit
  end

  def app_run(func)
    system('clear')
    method(func).call
    "\nEnter your choice (1 - 7): "
  end

  def run(state: true)
    ui = "\nEnter your choice (1 - 7): "
    while state
      print main_menu, ui
      state = (s = gets.chomp.to_i) != 7
      ui = (1..6).include?(s) ? app_run(main_items[s][:fun]) : "\nInvalid Choice!\nEnter your choice(1 - 7) again: "
    end
    exit
  end
end
