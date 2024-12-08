require "opal"
require 'glimmer-dsl-web'
require 'components/game_component'
require 'models/app'
require 'models/board'
require 'models/game'
require 'models/letter_play'
require 'models/player'
require 'presenters/board_presenter'
require 'presenters/game_presenter'
require 'presenters/square_presenter'

include Glimmer

app = App.new
Document.ready? do
  div do
    game_component(game: app.game_presenter)
  end
end
