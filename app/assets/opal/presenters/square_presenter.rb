require 'forwardable'

class SquarePresenter
  extend Forwardable

  attr_accessor :is_selected
  def_delegator :@square, :position
  def_delegator :@square, :is_played
  def_delegator :@square, :is_played=
  def_delegator :@square, :empty?
  def_delegator :@square, :value
  def_delegator :@square, :modifier
  def_delegator :@square, :has_unplayed_letter?
  def_delegator :@square, :replaceable?

  attr_reader :square
  attr_accessor :is_start_square
  attr_accessor :is_double_word
  attr_accessor :is_triple_word

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
    puts "@on_select: #{@on_select.inspect}"
    @on_select.call(@square.position)
  end
end
