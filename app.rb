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
    STDIN.getch
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
    print 'list all persons'
    puts 'Press Enter to continue ...'
    $stdin.getc
  end

  def create_a_person
    print 'create a person'
    puts 'Press Enter to continue ...'
    $stdin.getc
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
