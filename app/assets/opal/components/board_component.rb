require 'components/square_component'
require 'models/square'
class BoardComponent
  include Glimmer::Web::Component

  option :board

  markup do
    table do
      board.size.times do |row_index|
        tr do
          board.size.times do |col_index|
            td do
              square_component(square: board.squares[row_index][col_index])
            end
          end
        end
      end
    end
  end
end
