require 'rails_helper'

describe GamePresenter do
  subject { GamePresenter.new(game) }
  let(:tray_presenter) { subject.tray_presenter }
  let(:board_presenter) { subject.board_presenter }
  let(:game) { Game.new(board, tray, [player_1, player_2]) }
  let(:board) { Board.new(3) }
  let(:tray) { Tray.new(7, ['A', 'B', 'C', 'D']) }
  let(:player_1) { Player.new('player_1') }
  let(:player_2) { Player.new('player_2') }

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
        subject.board_square_selected([1, 1])
      end

      it 'marks the square as selected on the board' do
        subject.board_square_selected([2, 2])
        expect(board_presenter.selected_square).to eq(board.squares[2][2])
      end
    end

    context 'when a square is selected on the tray' do
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

    describe '#play_pressed' do
      it 'plays the word' do
        subject.tray_square_selected(2)
        subject.board_square_selected([1, 1])
        subject.play_pressed
        expect(board.squares[1][1].letter).to eq('C')
        expect(board.squares[1][1].is_played).to be_truthy
        expect(tray.squares[2].letter).to be_nil
      end
    end
  end
end