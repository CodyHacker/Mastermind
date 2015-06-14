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

  # def to_s
  #   puts "Number of pins: #{@number_of_pins}, Number of colors possible per pin: #{@number_of_colors}"
  # end

  private
  def random_color
    rand(@number_of_colors)
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

    # Thank you, Suslov from StackOverflow
    array1.inject(0) do |count, (i)| 
        if array2.include?(i)
            count += 1
            array2.delete_at(array2.index(i))
        end
        count
    end



  end

  def to_s
    puts "CodeMaker Code: #{@codemaker_code}, CodeBreaker Code: #{@guessed_code}"
  end


end


CODE_MAKER_CODE = CodeMaker.new.make_code

12.times do |guess|
  print "Enter your guess (ex. 0,1,4,5):  "
  my_guess = gets.chomp.split(',').map(&:to_i)
  # puts my_guess
  # p my_guess
  code_comparison = CodeCompareFeedback.new(my_guess, CODE_MAKER_CODE)
  if code_comparison.correct_items_correct_position == my_guess.length
    puts
    puts "You guessed the code, #{CODE_MAKER_CODE}!"
    puts
    exit
  end
  puts "On guess number: #{guess + 1}, there are #{code_comparison.correct_items_correct_position} correct items in the correct position and there are #{code_comparison.correct_items_only} correct items NOT in the correct position"
  puts "My guess: #{my_guess}, Codemaker code: #{CODE_MAKER_CODE} <----- For Debugging Only!"
end
puts
puts "I'm sorry, you did not guess the code, #{CODE_MAKER_CODE}, within the allotted 12 tries."


# code_maker = CodeMaker.new.make_code
#  code_guesser = CodeCompareFeedback.new([1,3,2,5],code_maker)
# puts "correct items in correct positions #{code_guesser.correct_items_correct_position}"
# puts "correct items/incorrect position: #{code_guesser.correct_items_only}"
# puts code_guesser

# code_guesser = CodeCompareFeedback.new([1,3,4,5],code_maker)
# puts "correct items in correct positions #{code_guesser.correct_items_correct_position}"
# puts "correct items/incorrect position: #{code_guesser.correct_items_only}"
# puts code_guesser


