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

  describe 'players' do
    it 'returns the players' do
      expect(subject.players).to match_array([player_1, player_2])
    end
  end

  describe 'pass' do
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

  describe 'board_square_selected' do
    before do
      tray_presenter.select_square(1)
      subject.board_square_selected(1, 1)
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
  end

  describe 'tray_square_selected' do
    it 'does' do
      board.select_square(0, 0)
      subject.tray_square_selected(0)
      expect(board.selected_square).to be_nil
      expect(game.selected_square).to eq([:tray, 0])
    end
  end
end