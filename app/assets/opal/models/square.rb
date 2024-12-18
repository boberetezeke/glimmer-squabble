class Square
  attr_accessor :letter

  def initialize(letter: nil)
    @letter = letter || 'B'
    @selected = false
  end

  def select
    @selected = true
  end
end