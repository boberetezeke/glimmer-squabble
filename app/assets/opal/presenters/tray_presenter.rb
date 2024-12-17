class TrayPresenter
  def initialize(tray)
    @tray = tray
    @square_presenters = Array.new(tray.size) do |col|
      sp = SquarePresenter.new(tray.squares[col])
      sp.on_select { |x, y| select_square(col, notify_on_select: true) }
      sp
    end
  end

  def on_select_square(&block)
    @on_select_square = block
  end

  def select_square(col, notify_on_select: false)
    @selected_square = col
    @on_select_square.call(col) if notify_on_select && @on_select_square
  end

  def selected_square
    return nil unless @selected_square

    @tray.squares[@selected_square]
  end

  def place_letter(index, letter)
    @tray.squares[index].letter = letter
  end
end
