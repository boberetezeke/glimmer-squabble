class Tray
  attr_reader :size, :squares

  def initialize(size, letters)
    @size = size
    @selected_index = nil
    @squares = Array.new(size) do |col|
      Square.new({col: col})
    end
    @squares.each_with_index do |square, index|
      square.letter = letters[index]
    end
  end

end
