module MainMenu
  def main_items
    {
      1 => { name: 'List all books', fun: :list_all_books },
      2 => { name: 'List all people', fun: :list_all_persons },
      3 => { name: 'Create a person', fun: :create_a_person },
      4 => { name: 'Create a book', fun: :create_a_book },
      5 => { name: 'Create a rental', fun: :create_a_rental },
      6 => { name: 'List all rentals for a given person id', fun: :list_all_rentals },
      7 => { name: 'Exit', fun: :exit }
    }
  end

  def back_mm(msg = '')
    print "\n\n", msg, "\nPress any key to return to main menu...."
    return yield if block_given?

    $stdin.getch
  end

  def main_menu
    system('clear')
    menu_ui = "\n|****** Welcome to School library App! ******|\n\n"
    main_items.each { |k, v| menu_ui += "#{k} - #{v[:name]}\n" }
    menu_ui += "\n"
    menu_ui
  end
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
  exit_app
end
