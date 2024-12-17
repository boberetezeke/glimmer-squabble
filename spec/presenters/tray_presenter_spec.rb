require 'rails_helper'

describe TrayPresenter do
  subject { TrayPresenter.new(tray) }
  let(:tray) { Tray.new(7, ['A', 'B', 'C', 'D']) }

  describe '#select_square' do
    it 'selects a square' do
      subject.select_square(1)
      expect(subject.selected_square).to eq(tray.squares[1])
    end

    it 'notifies the on_selector of the selected square' do
      subject.on_select_square do |col|
        expect(col).to eq(1)
      end
      subject.select_square(1, notify_on_select: true)
    end

    it 'unselects a square' do
      subject.select_square(1)
      subject.select_square(nil)
      expect(subject.selected_square).to be_nil
    end
  end

  describe '#place_letter' do
    it 'places a letter on the square' do
      subject.place_letter(1, 'A')
      expect(tray.squares[1].letter).to eq('A')
    end
  end
end