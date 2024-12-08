class Game
  attr_reader :board, :tray, :players
  def initialize(board, tray, players)
    @board = board
    @tray = tray
    @players = players
    @current_player_index = 0
  end

  def current_player
    @players[@current_player_index]
  end

  def pass
    @current_player_index = (@current_player_index + 1) % players.size
  end

  def play_letters(letter_plays)
    letter_plays.each do |letter_play|
      @board.play_letter(letter_play)
    end
  end

  def unplay_letters(letter_plays)
    letter_plays.each do |letter_play|
      @board.unplay_letter(letter_play)
    end
  end
end