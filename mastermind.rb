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
    (array1 & array2).count
  end

  def to_s
    puts "CodeMaker Code: #{@codemaker_code}, CodeBreaker Code: #{@guessed_code}"
  end

end

code_maker = CodeMaker.new.make_code
 code_guesser = CodeCompareFeedback.new([1,3,2,5],code_maker)
puts "correct items in correct positions #{code_guesser.correct_items_correct_position}"
puts "correct items/incorrect position: #{code_guesser.correct_items_only}"
puts code_guesser


