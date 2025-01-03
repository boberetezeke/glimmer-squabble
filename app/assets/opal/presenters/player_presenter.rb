require 'forwardable'

class PlayerPresenter
  extend Forwardable

  attr_reader :player

  def_delegator :@player, :name
  def_delegator :@player, :name=
  def_delegator :@player, :score
  def_delegator :@player, :score=
  def_delegator :@player, :letters
  def_delegator :@player, :letters=

  def initialize(player)
    @player = player
  end

  def on_play_pressed(&block)
    @on_play_pressed = block
  end

  def on_pass_pressed(&block)
    @on_pass_pressed = block
  end

  def play_pressed
    @on_play_pressed.call
  end

  def pass_pressed
    @on_pass_pressed.call
  end

  def name
    player.name
  end

  def score
    player.score
  end
end