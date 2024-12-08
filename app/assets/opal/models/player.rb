class Player
  attr_accessor :name, :score, :squares

  def initialize(name)
    @name = name
    @score = 100
    @squares = Array.new(7) do |index|
      (65 + index).chr
    end
  end
end