require 'forwardable'

class SquarePresenter
  extend Forwardable

  def_delegator :@square, :letter
  def_delegator :@square, :letter=

  def initialize(square)
    @square = square
  end

  def on_select(&block)
    @on_select = block
  end

  def select(notify_on_select: false)
    @on_select.call(@square.x, @square.y) if notify_on_select && @on_select
  end

  def selected
    @on_select.call(@square.row, @square.col)
  end
end
