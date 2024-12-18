require 'forwardable'

class SquarePresenter
  extend Forwardable

  def_delegator :@square, :letter
  def_delegator :@square, :letter=
  attr_accessor :is_selected

  def initialize(square)
    @square = square
    @is_selected = false
  end

  def on_select(&block)
    @on_select = block
  end

  def select(selected)
    self.is_selected = selected
  end

  def selected
    puts "square_presenter#selected:#{@square.position}"
    @on_select.call(@square.position)
  end
end
