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
    @on_select.call(@square.position) if notify_on_select && @on_select
  end

  def selected
    puts "square_presenter#selected:#{@square.position}"
    @on_select.call(@square.position)
  end
end
