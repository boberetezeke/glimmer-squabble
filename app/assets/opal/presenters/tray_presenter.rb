class TrayPresenter
  def initialize(tray)
    @tray = tray
  end

  def select_square(index)
    @selected_square = index
  end

  def selected_square
    return nil unless @selected_square

    @tray.squares[@selected_square]
  end

  def place_letter(index, letter)
    @tray.squares[index].letter = letter
  end
end
