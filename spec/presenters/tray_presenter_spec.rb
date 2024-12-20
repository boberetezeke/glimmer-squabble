require 'rails_helper'

describe TrayPresenter do
  subject { TrayPresenter.new(tray) }
  let(:tray) { Tray.new(7, ['A', 'B', 'C', 'D']) }

  describe '#select_square' do
    it 'selects a square' do
      expect(subject.square_presenters[1]).to receive(:select).with(true)
      subject.select_square(1)
      expect(subject.selected_square).to eq(tray.squares[1])
    end

    it 'selects another square' do
      expect(subject.square_presenters[1]).to receive(:select).with(true)
      subject.select_square(1)
      expect(subject.square_presenters[1]).to receive(:select).with(false)
      expect(subject.square_presenters[2]).to receive(:select).with(true)
      subject.select_square(2)
      expect(subject.selected_square).to eq(tray.squares[2])
    end

    it 'unselects a square' do
      expect(subject.square_presenters[1]).to receive(:select).with(true)
      subject.select_square(1)
      expect(subject.square_presenters[1]).to receive(:select).with(false)
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