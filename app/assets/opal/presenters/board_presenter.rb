require 'forwardable'

class BoardPresenter
  extend Forwardable

  def_delegator :@board, :size
  def_delegator :@board, :squares

  attr_reader :square_presenters

  def initialize(board)
    @board = board
    @square_presenters = Array.new(board.size) do |row|
      Array.new(board.size) do |col|
        sp = SquarePresenter.new(board.squares[row][col])
        sp.on_select { |position|
          puts "board_presenter#initialize: #{position}"
          square_selected(position)
        }
        sp
      end
    end
  end

  def set_styles
    @square_presenters.each do |row|
      row.each do |square_presenter|
        modifier = square_presenter.modifier
        if modifier&.start_square?
          square_presenter.is_start_square = true
        elsif modifier&.double_word?
          square_presenter.is_double_word = true
        elsif modifier&.triple_word?
          square_presenter.is_triple_word = true
        end
      end
    end
  end

  def on_select_square(&block)
    @on_select_square = block
  end

  def square_selected(position)
    puts "board_presenter#square_selected(#{position})"
    @on_select_square.call(position) if @on_select_square
  end

  def select_square(board_position)
    srow, scol = @selected_position
    s_square_presenter = @square_presenters[srow][scol] if @selected_position
    row, col = board_position
    n_square_presenter = @square_presenters[row][col] if board_position

    return if n_square_presenter&.is_played

    if board_position.nil?
      s_square_presenter.select(false) if @selected_position
      @selected_position = nil
    else
      s_square_presenter.select(false) if @selected_position
      if @selected_position == board_position
        @selected_position = nil
      else
        n_square_presenter.select(true)
        @selected_position = board_position
      end
    end
  end

  def selected_square
    return nil unless @selected_position

    srow, scol = @selected_position
    @board.squares[srow][scol]
  end

  def selected_position
    @selected_position
  end

  def square_presenters_for(position)
    row, col = position
    @square_presenters[row][col]
  end

  def start_square_presenter
    position = @board.start_square_position
    position.nil? ? nil : square_presenters_for(position)
  end

  def place_letter(position, letter)
    row, col = position
    puts "board_presenter#place_letter(#{row},#{col},#{letter})"
    @square_presenters[row][col].letter = letter
  end
end
