class BoardPresenter
  def initialize(board)
    @board = board
  end

  def select_square(x, y)
    @selected_square = x.nil? ? nil : [x, y]
  end

  def selected_square
    return nil unless @selected_square

    @board.squares[@selected_square[0]][@selected_square[1]]
  end

  def place_letter(row, col, letter)
    @board.squares[row][col].letter = letter
  end
end
