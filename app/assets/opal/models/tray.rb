class Tray
  attr_reader :size

  def initialize(size, letters)
    @size = size
    @selected_index = nil
    @squares = Array.new(size) do |row|
      nil
    end
  end

  def select_square(index)
    @selected_index = index
  end

  def selected_square

  end
end
