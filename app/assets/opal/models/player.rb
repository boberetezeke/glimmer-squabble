class Player
  attr_accessor :name, :score, :letters

  def initialize(name, letters: [])
    @name = name
    @score = 0
    @letters = letters
  end

  def clear_letters
    @letters = []
  end

  def add_letter(letter)
    @letters << letter
  end

  def remove_letter(letter)
    index = @letters.index(letter)
    @letters.delete_at(index) if index
  end
end