require 'rails_helper'

describe GamePresenter do
  subject { GamePresenter.new(game) }
  let(:tray_presenter) { subject.tray_presenter }
  let(:board_presenter) { subject.board_presenter }
  let(:game) { Game.new(board, bag, tray, [player_1, player_2]) }
  let(:bag) { Bag.new('MNOPQRS') }
  let(:board) { Board.new(5) }
  let(:tray) { Tray.new(7, ['A', 'B', 'C', 'D']) }
  let(:player_1) { Player.new('player_1', letters: ['A', 'B', 'C', 'D']) }
  let(:player_2) { Player.new('player_2', letters: ['M', 'N', 'O', 'P']) }
  let(:player_1_presenter) { subject.player_presenters.find{ |pp| pp.player == player_1} }
  let(:player_2_presenter) { subject.player_presenters.find{ |pp| pp.player == player_2} }

  describe '#current_player' do
    it 'is the first player' do
      expect(subject.current_player).to eq(player_1)
    end
  end

  describe '#players' do
    it 'returns the players' do
      expect(subject.players).to match_array([player_1, player_2])
    end
  end

  describe '#pass' do
    it 'goes to the next player on pass' do
      subject.pass
      expect(subject.current_player).to eq(player_2)
    end

    it 'goes to the original player on 2 passes' do
      subject.pass
      subject.pass
      expect(subject.current_player).to eq(player_1)
    end
  end

  describe '#board_square_selected' do
    context 'when there is a played letter on the selected square' do
      it 'doesnt allow a played letter to be selected' do
        board.squares[1][1].letter = 'A'
        board.squares[1][1].is_played = true
        subject.board_square_selected([1, 1])
        expect(board_presenter.selected_square).to be_nil
      end
    end

    context 'when nothing is selected in the tray or the board' do
      it 'marks the square as selected on the board' do
        subject.board_square_selected([1, 1])
        expect(board_presenter.selected_square).to eq(board.squares[1][1])
      end
    end

    context 'when the same square is selected on the board' do
      it 'marks the square as selected on the board' do
        subject.board_square_selected([1, 1])
        expect(board_presenter.selected_square).to eq(board.squares[1][1])
        subject.board_square_selected([1, 1])
        expect(board_presenter.selected_square).to be_nil
      end
    end

    context 'when a different square is selected on the board' do
      before do
        subject.board_presenter.select_square([1, 1])
      end

      context 'when both squares are empty' do
        it 'marks the square as selected on the board' do
          subject.board_square_selected([2, 2])
          expect(board_presenter.selected_square).to eq(board.squares[2][2])
        end
      end

      context 'when the selected square is an unplayed letter and the new square is empty' do
        before do
          subject.board_presenter.place_letter([1, 1], 'Z')
          subject.placed_letters << PlacedLetter.new([1, 1], 'Z')
          subject.board_square_selected([2, 2])
        end

        it 'unselects the square on the board' do
          expect(board_presenter.selected_square).to be_nil
        end

        it 'updates the position of the placed letter' do
          expect(subject.placed_letters).to eq([PlacedLetter.new([2, 2], 'Z')])
        end

        it 'clears the letter on the board for the old position' do
          expect(board_presenter.square_presenters_for([1,1]).raw_letter).to be_nil
        end

        it 'moves the letter on the board for the new position' do
          expect(board_presenter.square_presenters_for([2,2]).letter).to eq('Z')
        end
      end

      context 'when the selected square is an unplayed letter and the new square is an unplayed letter' do
        before do
          subject.board_presenter.place_letter([1, 1], 'Z')
          subject.placed_letters << PlacedLetter.new([1, 1], 'Z')
          subject.board_presenter.place_letter([2, 2], 'Y')
          subject.placed_letters << PlacedLetter.new([2, 2], 'Y')
          subject.board_square_selected([2, 2])
        end

        it 'unselects the square on the board' do
          expect(board_presenter.selected_square).to be_nil
        end

        it 'updates the position of the placed letters so that they are swapped' do
          expect(subject.placed_letters).to match_array([PlacedLetter.new([2, 2], 'Z'), PlacedLetter.new([1, 1], 'Y')])
        end

        it 'swaps the positions of the letters' do
          expect(board_presenter.square_presenters_for([1,1]).letter).to eq('Y')
          expect(board_presenter.square_presenters_for([2,2]).letter).to eq('Z')
        end
      end
    end

    context 'when a square is selected on the tray' do
      context 'when the square is empty' do
        before do
          tray_presenter.select_square(1)
          subject.board_square_selected([1, 1])
        end

        it 'unselects the square on the layer' do
          expect(tray_presenter.selected_square).to be_nil
        end

        it 'unselects the square on the board' do
          expect(board_presenter.selected_square).to be_nil
        end

        it 'places the letter on the board' do
          expect(board.squares[1][1].letter).to eq('B')
        end

        it 'adds to the played letters' do
          expect(subject.placed_letters).to eq([PlacedLetter.new([1, 1], 'B')])
        end

        it 'clears the letter on the tray' do
          expect(tray.squares[1].letter).to be_nil
        end
      end

      context 'when the square is an unplayed letter' do
        before do
          board.squares[1][1].letter = 'Z'
          subject.placed_letters << PlacedLetter.new([1, 1], 'Z')
          tray_presenter.select_square(1)
          subject.board_square_selected([1, 1])
        end

        it 'unselects the square on the layer' do
          expect(tray_presenter.selected_square).to be_nil
        end

        it 'unselects the square on the board' do
          expect(board_presenter.selected_square).to be_nil
        end

        it 'places the letter on the board' do
          expect(board.squares[1][1].letter).to eq('B')
        end

        it 'adds to the played letters' do
          expect(subject.placed_letters).to eq([PlacedLetter.new([1, 1], 'B')])
        end

        it 'replaces letter on the tray with the letter on the board' do
          expect(tray.squares[1].letter).to eq('Z')
        end
      end
    end
  end

  describe '#tray_square_selected' do
    context 'when there are no board squares selected' do
      it 'selects a square' do
        subject.tray_square_selected(2)
        expect(tray_presenter.selected_square).not_to be_nil
      end

      it 'unselects a already selected square' do
        subject.tray_square_selected(2)
        expect(tray_presenter.selected_square).not_to be_nil
        subject.tray_square_selected(3)
        expect(tray_presenter.selected_square).not_to be_nil
      end

      it 'unselects a the same selected square' do
        subject.tray_square_selected(2)
        expect(tray_presenter.selected_square).not_to be_nil
        subject.tray_square_selected(2)
        expect(tray_presenter.selected_square).to be_nil
      end
    end

    context 'when a square on the board is selected' do
      before do
        board.squares[1][1].letter = 'B'
        board_presenter.select_square([1, 1])
        subject.tray_square_selected(4)
      end

      it 'unselects the square on the board' do
        expect(board_presenter.selected_square).to be_nil
      end

      it 'unselects the square on the tray' do
        expect(tray_presenter.selected_square).to be_nil
      end

      it 'clears a letter back on the board' do
        expect(board.squares[1][1].letter).to be_nil
      end

      it 'moves a letter back to the tray' do
        expect(tray.squares[4].letter).to eq('B')
      end
    end

    describe '#play_invalid_reason' do
      context 'when the letters placed dont touch the start square' do
        it 'returns invalid' do
          board.squares[2][0].modifier = SquareModifier.new(SquareModifier::START_SQUARE)
          subject.tray_square_selected(2)
          subject.board_square_selected([1, 1])
          subject.tray_square_selected(0)
          subject.board_square_selected([1, 2])
          expect(subject.play_invalid_reason).to eq(:not_covering_start_square)
        end

        context 'when the letters placed dont touch any played letters' do
          it 'returns invalid' do
            board.squares[2][0].modifier = SquareModifier.new(SquareModifier::START_SQUARE)
            board.squares[2][0].letter = 'Z'
            board.squares[2][0].is_played = true

            subject.tray_square_selected(2)
            subject.board_square_selected([1, 1])
            subject.tray_square_selected(0)
            subject.board_square_selected([1, 2])
            expect(subject.play_invalid_reason).to eq(:not_adjacent_to_played_letter)
          end
        end

        context 'when the letters placed arent in a row or column' do
          it 'returns invalid' do
            board.squares[1][1].modifier = SquareModifier.new(SquareModifier::START_SQUARE)

            subject.tray_square_selected(2)
            subject.board_square_selected([1, 1])
            subject.tray_square_selected(0)
            subject.board_square_selected([2, 2])
            expect(subject.play_invalid_reason).to eq(:placed_letters_not_in_a_line)
          end
        end

        context 'when the letters arent connected together to played letters' do
          it 'returns invalid' do
            board.squares[2][2].modifier = SquareModifier.new(SquareModifier::START_SQUARE)
            board.squares[2][2].letter = 'Z'
            board.squares[2][2].is_played = true

            subject.tray_square_selected(1)
            subject.board_square_selected([2, 1])
            subject.tray_square_selected(2)
            subject.board_square_selected([2, 4])
            expect(subject.play_invalid_reason).to eq(:placed_letters_not_connected)
          end
        end
      end
    end

    describe '#play_pressed' do
      let(:return_before) { :nothing }

      context 'when the play is invalid' do
        context 'when the letters placed dont touch the start square' do
          it 'returns invalid' do
            board.squares[0][0].modifier = SquareModifier.new(SquareModifier::START_SQUARE)
            subject.tray_square_selected(2)
            subject.board_square_selected([1, 1])
            subject.tray_square_selected(0)
            subject.board_square_selected([1, 2])
            expect(subject.play_pressed(return_before: return_before)).to eq(:not_covering_start_square)
          end
        end
      end

      context 'when it is a valid play' do
        before do
          subject.tray_square_selected(2)
          subject.board_square_selected([1, 1])
          subject.tray_square_selected(0)
          subject.board_square_selected([1, 2])
          board.squares[1][1].modifier = SquareModifier.new(SquareModifier::DOUBLE_LETTER)
          board.squares[1][2].modifier = SquareModifier.new(SquareModifier::START_SQUARE)
          subject.play_pressed(return_before: return_before)
        end

        it 'places the letters' do
          expect(board.squares[1][1].letter).to eq('C')
          expect(board.squares[1][2].letter).to eq('A')
        end

        it 'marks them as played' do
          expect(board.squares[1][1].is_played).to be_truthy
          expect(board.squares[1][2].is_played).to be_truthy
        end

        it 'saves the play in the play history' do
          expect(subject.play_history).to eq(
            [
              PlayedWord.new(player_1, [
                  PlacedLetter.new([1, 1], 'C'),
                  PlacedLetter.new([1, 2], 'A'),
                ]
              )
            ]
          )
        end

        it 'clears the placed letters' do
          expect(subject.placed_letters).to be_empty
        end

        it 'takes the letters out of the bag' do
          expect(bag.letters.size).to eq(5)
        end

        it 'adds to the players score' do
          expect(player_1.score).to eq(((3*2) + 1) * 2)
        end

        context 'when returns before go to next player' do
          let(:return_before) { :go_to_next_player }

          it 'replaces the played letter with a letter from the bag' do
            expect(tray.squares[2].letter).not_to be_nil
          end
        end

        context 'when returns before we place next players letters' do
          let(:return_before) { :place_next_player_letters }

          it 'clears out the tray' do
            expect(tray.squares.map(&:letter)).to eq([nil, nil, nil, nil, nil, nil, nil])
          end
        end

        context 'when play advances to the next player' do
          it 'advances the player' do
            expect(subject.current_player_presenter).to eq(player_2_presenter)
          end

          it 'replaces the letters on the tray with the next players letters' do
            expect(tray.squares.map(&:letter)).to eq(['M', 'N', 'O', 'P', nil, nil, nil])
          end

          it 'adds to the players score' do
            expect(player_1.score).to eq(((3*2) + 1) * 2)
          end
        end
      end
    end

    describe '#pass_pressed' do
      before do
        subject.tray_square_selected(2)
        subject.board_square_selected([1, 1])
        subject.pass_pressed
      end

      it 'clears the letters off of the board' do
        expect(board.squares[1][1].letter).to be_nil
      end

      it 'clears the placed letters' do
        expect(subject.placed_letters).to be_empty
      end

      it 'advances the player' do
        expect(subject.current_player_presenter).to eq(player_2_presenter)
      end

      it 'replaces the letters on the tray with the next players letters' do
        expect(tray.squares.map(&:letter)).to eq(['M', 'N', 'O', 'P', nil, nil, nil])
      end
    end
  end
end