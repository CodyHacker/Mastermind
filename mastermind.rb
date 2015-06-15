class CodeMaker
  # CodeMaker creates the code. It can be called with number of pins and number of colors
  # but defaults to 4 pins, 6 colors, and currently allows for duplicates.

  attr_writer  :number_of_pins, :number_of_colors
  
  def initialize(number_of_pins=4, number_of_colors=6)
    @number_of_pins = number_of_pins
    @number_of_colors = number_of_colors
    @@the_code = []
  end

  def make_code
    @number_of_pins.times do
      @@the_code << random_color
    end
    @@the_code
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

    # Thank you, Suslov from StackOverflow, for this beautiful little bit

    array1.select{|e| (index = array2.index(e) and array2.delete_at index)}.count
  end

  def to_s
    puts "CodeMaker Code: #{@codemaker_code}, CodeBreaker Code: #{@guessed_code}"
  end

end

class HumanCodeBreaker
  def initialize
    @code_maker_code = CodeMaker.new.make_code
  end

  def play_game
    12.times do |guess|
      print "Enter your guess (ex. 1,2,3,6): "
      my_guess = gets.chomp.scan(/\d/)[0,4].map(&:to_i)
      puts
      code_comparison = CodeCompareFeedback.new(my_guess, @code_maker_code)
      if code_comparison.correct_items_correct_position == my_guess.length
        puts
        puts "You guessed the code, #{@code_maker_code}!"
        puts
        exit
      end
      puts "On guess number: #{guess + 1}, there are #{code_comparison.correct_items_correct_position} correct items in the correct position and there are #{code_comparison.correct_items_only} correct items NOT in the correct position"
      puts "My guess: #{my_guess}, Codemaker code: #{@code_maker_code} <----- For Debugging Only!"
      puts
    end
    puts
    puts "I'm sorry, you did not guess the code, #{@code_maker_code}, within the allotted 12 tries."
  end

end

new_game = HumanCodeBreaker.new
new_game.play_game

