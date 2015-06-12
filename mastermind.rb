class CodeMaker

  attr_writer  :number_of_pins, :number_of_colors
  
  def initialize(number_of_pins=4, number_of_colors=6)
    @number_of_pins = number_of_pins
    @number_of_colors = number_of_colors
    @the_code = []
  end

  def make_code
    @number_of_pins.times do
      @the_code << random_color
    end
    @the_code
  end

  # def to_s
  #   puts "Number of pins: #{@number_of_pins}, Number of colors possible per pin: #{@number_of_colors}"
  # end


private
  def random_color
    rand(@number_of_colors)
  end
  
end

code_maker1 = CodeMaker.new
code_maker2 = CodeMaker.new


p code_maker1.make_code
p code_maker2.make_code