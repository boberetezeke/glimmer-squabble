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
     @square_presenters[@selected_square].select(false) if @selected_square
     @selected_square = nil
    else
      @square_presenters[@selected_square].select(false) if @selected_square
      if @selected_square == col
        @selected_square = nil
      else
        @square_presenters[col].select(true)
        @selected_square = col
      end
    end
  end

  def selected_square
    return nil unless @selected_square

    @tray.squares[@selected_square]
  end

  def selected_position
    @selected_square
  end

  def place_letter(col, letter)
    puts "tray_presenter#place_letter(#{col},#{letter})"
    @square_presenters[col].letter = letter
  end
end
