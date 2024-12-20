require 'rails_helper'

describe BoardPresenter do
  subject { BoardPresenter.new(board) }
  let(:board) { Board.new(3) }

  describe '#select_square' do
    it 'selects a square' do
      expect(subject.square_presenters[1][1]).to receive(:select).with(true)
      subject.select_square(1, 1)
      expect(subject.selected_square).to eq(board.squares[1][1])
    end

    it 'unselects a square' do
      expect(subject.square_presenters[1][1]).to receive(:select).with(true)
      subject.select_square(1, 1)
      expect(subject.square_presenters[1][1]).to receive(:select).with(false)
      subject.select_square(nil, nil)
      expect(subject.selected_square).to be_nil
    end

    it 'selects another square' do
      expect(subject.square_presenters[1][1]).to receive(:select).with(true)
      subject.select_square(1, 1)
      expect(subject.square_presenters[1][1]).to receive(:select).with(false)
      expect(subject.square_presenters[2][2]).to receive(:select).with(true)
      subject.select_square(2, 2)
      expect(subject.selected_square).not_to be_nil
    end
  end

  describe '#place_letter' do
    it 'places a letter on the board' do
      subject.place_letter(1, 1, 'A')
      expect(board.squares[1][1].letter).to eq('A')
    end
  end
end
