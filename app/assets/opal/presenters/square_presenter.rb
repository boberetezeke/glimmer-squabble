require 'forwardable'

class SquarePresenter
  extend Forwardable

  attr_accessor :is_selected
  def_delegator :@square, :is_played
  def_delegator :@square, :is_played=
  def_delegator :@square, :empty?
  def_delegator :@square, :score
  def_delegator :@square, :has_unplayed_letter?
  def_delegator :@square, :replaceable?

  attr_reader :square

  def initialize(square)
    @square = square
    @is_selected = false
  end

  def letter
    @square.letter || "_"
  end

  def raw_letter
    @square.letter
  end

  def letter=(letter)
    @square.letter = letter
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
