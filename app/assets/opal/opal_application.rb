require "opal"
require 'glimmer-dsl-web'
require 'components/game_component'
require 'components/board_component'
require 'components/tray_component'
require 'components/score_component'
require 'components/square_component'
require 'components/player_component'
require 'models/app'
require 'models/board'
require 'models/game'
require 'models/letter_play'
require 'models/player'
require 'models/square'
require 'models/tray'
require 'models/placed_letter'
require 'presenters/game_presenter'
require 'presenters/board_presenter'
require 'presenters/tray_presenter'
require 'presenters/square_presenter'
require 'presenters/player_presenter'

include Glimmer

app = App.new
Document.ready? do
  div do
    game_component(game_presenter: app.game_presenter)
  end
end
