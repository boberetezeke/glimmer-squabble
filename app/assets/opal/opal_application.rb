require "opal"
require 'glimmer-dsl-web'
require 'components/game_component'
require 'models/app'

include Glimmer

app = App.new
Document.ready? do
  div do
    game_component(game: app.game)
  end
end
