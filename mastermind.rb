module Chooser
  private
  def first_or_second_choice?(choice1, choice2, msg)
    a_or_b = ''
    until a_or_b == choice1 || a_or_b == choice2
      print msg
      begin
        system("stty raw -echo")
        a_or_b = STDIN.getc.downcase
      ensure
        system("stty -raw echo")
      end
      puts
    end
    a_or_b == choice1 ? true : false
  end

  def get_the_number(msg,guess_number=nil)
    my_guess = ''
    until my_guess.length == @number_of_pins && my_guess.all? {|element| element.between?(1, @number_of_colors)}
      # print "Enter your guess ##{guess_number + 1}: "
      print msg
      my_guess = gets.chomp.scan(/\d/)[0,@number_of_pins].map(&:to_i)
    end
    my_guess
  end


end

class CodeMaker
  # CodeMaker creates the code. It can be called with number of pins and number of colors
  # but defaults to 4 pins, 6 colors, and currently allows for duplicates.

  attr_accessor  :number_of_pins, :number_of_colors

  def initialize(number_of_pins=4, number_of_colors=6)
    @number_of_pins = number_of_pins
    @number_of_colors = number_of_colors
  end

  def make_code
    @the_code = []
    @number_of_pins.times do
      @the_code << random_color
    end
    @the_code
  end

  def to_s
    puts "Number of pins: #{@number_of_pins}, Number of colors possible per pin: #{@number_of_colors}"
  end

  private
  def random_color
    rand(@number_of_colors)+1
  end

end

class CodeCompareFeedback
  # CodeCompareFeedback takes a guessed code and compares it to the code created by CodeMaker.
  # It returns the number of correct items/correct positions as well as correct
  # items/incorrect positions. Naturally, it will return number_of_items_in_code
  # correct items/correct positions.

  attr_writer :guessed_code, :codemaker_code

  def initialize(guessed_code=nil, codemaker_code=nil)
    @guessed_code = guessed_code
    @codemaker_code = codemaker_code
  end

  def correct_items_correct_position
    @codemaker_code.zip(@guessed_code).map { |a, b| a == b }.count(true)
  end

  def correct_items_only
    array1, array2 = @codemaker_code.zip(@guessed_code).delete_if { |a, b| a == b }.transpose

    # (Multiset.new(array1) & Multiset.new(array2)).size 

    # Thank you, Suslov from StackOverflow, for this beautiful little bit (no gem reliance)

    array1.select{|e| (index = array2.index(e) and array2.delete_at index)}.count
  end

  def to_s
    puts "CodeMaker Code: #{@codemaker_code}, CodeBreaker Code: #{@guessed_code}"
  end

end

class HumanPlayer
  include Chooser

  attr_writer :number_of_tries

  def initialize(number_of_tries=12)
    @my_code_maker = CodeMaker.new
    @code_maker_code = @my_code_maker.make_code
    @number_of_colors = @my_code_maker.number_of_colors
    @number_of_pins = @my_code_maker.number_of_pins
    @number_of_tries = number_of_tries
    @code_comparison = CodeCompareFeedback.new(nil, @code_maker_code)
  end

  def play_game
    welcome_the_player
    @number_of_tries.times do |guess_number|
      @my_guess = get_the_number("Enter your guess ##{guess_number + 1}: ",guess_number)
      @code_comparison.guessed_code = @my_guess
      @code_comparison.correct_items_correct_position == @my_guess.length ? message_player_wins(guess_number) : message_guess_feedback(guess_number)
    end
    message_player_loses
  end


  private
  def welcome_the_player
    puts "The Secret Code is #{@number_of_pins} digits long and consists of the digits 1 - #{@number_of_colors}. You have #{@number_of_tries} tries to try and guess it. Good luck!"
  end

  def message_player_loses
    puts
    puts "I'm sorry, you did not guess the code, #{@code_maker_code}, within the allotted #{@number_of_tries} tries."
  end

  def message_guess_feedback(guess_number)
    puts
    puts "On try number: #{guess_number + 1}, there are #{@code_comparison.correct_items_correct_position} correct items in the correct position and there are #{@code_comparison.correct_items_only} correct items NOT in the correct position."
    puts "My guess: #{@my_guess}, Codemaker code: #{@code_maker_code} <----- For Debugging Only!" if $VERBOSE # run with ruby -w mastermind.rb
    puts
  end

  def message_player_wins(guess_number)
    puts
    puts "You guessed the code, #{@code_maker_code}, in #{guess_number + 1} tries!"
    puts
    exit
  end
end

class MasterMind
  include Chooser
  def initialize
    greet_player
    show_instructions if first_or_second_choice?('y','n','Would you like instructions (y/n)? ')
    new_game = first_or_second_choice?('b','m','Would you like to be the codeMaker or codeBreaker (m/b)? ') ? HumanPlayer.new : ComputerPlayer.new(10000)
    new_game.play_game
  end

  private

  def greet_player
    puts 'Welcome to Mastermind!'
  end

  def show_instructions
    puts
    puts 'Mastermind is a code puzzle guessing game. You can choose to be the codebreaker, or the codemaker.'
    puts 'If you choose to be the codebreaker, then the computer will choose a code that consists of 4 digits.'
    puts 'Each digit can be from 1 to 6. Repeats are allowed. If you should choose to be the code maker, then'
    puts 'you will choose the code in a similar manner, 4 digits long, each digit between 1 and 6, and the computer'
    puts 'will guess. Now, the important thing is the feedback, otherwise it is just random luck. For example, if you'
    puts 'choose to be the codebreaker, and you guess some 4 digit number, the computer will tell you how many numbers'
    puts 'are correct, and in the correct position, as well as how many are correct, but in the wrong position.'
    puts 'For example, if the random chosen code by the computer is (3,4,5,5) and your first guess is (1,5,4,5), the'
    puts 'computer will report back that you have 1 number that is correct and in the correct position, and 2 numbers'
    puts 'which are correct, but in the wrong position. Of course, when you play the codemaker and the computer guesses,'
    puts 'you must report back in a similar manner, so the computer can formulate a guess. Good luck and have fun!'
    puts
  end
    
end

class ComputerPlayer < HumanPlayer
  include Chooser
  def play_game
    welcome_the_player
    @human_chosen_secret_code = get_the_number('Enter your secret code:  ')
    puts "You chose: #{@human_chosen_secret_code} as the secret code. The computer will now try to guess it in #{@number_of_tries} tries"
    @number_of_tries.times do |guess_number|
      puts "On try #{guess_number+1}, computer guessed: #{@code_maker_code}"
      if @human_chosen_secret_code == @code_maker_code
        puts "Computer guessed correctly and wins!"
        exit
      else
        @code_maker_code = @my_code_maker.make_code
      end
    end
    puts "Computer did not correctly guess the code"
    
  end

  private

  def welcome_the_player
    puts "The Secret Code is #{@number_of_pins} digits long and consists of the digits 1 - #{@number_of_colors}. The computer has #{@number_of_tries} tries to try and guess it."
    puts "You will choose the code based on this criteria and provide feedback and the computer will attempt to guess it."
  end
end

MasterMind.new

