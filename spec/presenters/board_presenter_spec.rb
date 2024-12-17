require 'rails_helper'

describe BoardPresenter do
  subject { BoardPresenter.new(board) }
  let(:board) { Board.new(3) }

  describe '#select_square' do
    it 'selects a square' do
      subject.select_square(1, 1)
      expect(subject.selected_square).to eq(board.squares[1][1])
    end

    it 'notifies the on_selector of the selected square' do
      subject.on_select_square do |x, y|
        expect([x, y]).to eq([1, 1])
      end
      subject.select_square(1, 1, notify_on_select: true)
    end

    it 'unselects a square' do
      subject.select_square(1, 1)
      subject.select_square(nil, nil)
      expect(subject.selected_square).to be_nil
    end
  end

  describe '#place_letter' do
    it 'places a letter on the board' do
      subject.place_letter(1, 1, 'A')
      expect(board.squares[1][1].letter).to eq('A')
    end
  end
end
