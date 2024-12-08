class BoardComponent
  include Glimmer::Web::Component

  option :board_presenter

  markup do
    table do
      board.size.times do |row_index|
        tr do
          board.size.times do |col_index|
            td do
              square_component(square_presenter: board_presenter.square_presenters[row_index][col_index])
            end
          end
        end
      end
    end
  end
end
