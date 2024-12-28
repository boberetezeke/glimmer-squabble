require 'forwardable'

class BagPresenter
  extend Forwardable

  def_delegator :@bag, :letters
  def_delegator :@bag, :letters=

  def initialize(bag)
    @bag = bag
  end

  def draw(num_letters)
    chars = letters.chars
    drawn_letters = chars.sample(num_letters)
    drawn_letters.size.times { |i| chars.delete_at(chars.index(drawn_letters[i])) }
    self.letters = chars.join

    drawn_letters
  end
end