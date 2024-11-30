require 'models/square'

class Player
  attr_accessor :name, :score, :squares

  def initialize(name)
    @name = name
    @score = 100
    @squares = Array.new(7) { |index| Square.new(0,index, value: (65 + index).chr) }
  end
end