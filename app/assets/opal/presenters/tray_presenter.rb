class TrayPresenter
  attr_reader :square_presenters

  def initialize(tray)
    @tray = tray
    @square_presenters = Array.new(tray.size) do |col|
      sp = SquarePresenter.new(tray.squares[col])
      sp.on_select { |position| square_selected(position[:col]) }
      sp
    end
  end

  def on_select_square(&block)
    @on_select_square = block
  end

  def square_selected(col)
    puts "tray_presenter#square_selected(#{col})"
    @on_select_square.call(col) if @on_select_square
  end

  def select_square(col)
    puts "tray_presenter#select_square(#{col})"
    if col.nil?
     @square_presenters[@selected_position].select(false) if @selected_position
     @selected_position = nil
    else
      @square_presenters[@selected_position].select(false) if @selected_position
      if @selected_position == col
        @selected_position = nil
      else
        @square_presenters[col].select(true)
        @selected_position = col
      end
    end
  end

  def selected_square
    return nil unless @selected_position

    @tray.squares[@selected_position]
  end

  def selected_position
    @selected_position
  end

  def place_letter(position, letter)
    col = position
    puts "tray_presenter#place_letter(#{col},#{letter})"
    @square_presenters[col].letter = letter
  end

  def first_empty_position
    @square_presenters.each_with_index do |sp, i|
      return i if sp.square.letter.nil?
    end
    nil
  end
end
