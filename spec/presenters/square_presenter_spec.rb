require 'rails_helper'

describe SquarePresenter do
  subject { SquarePresenter.new(square) }
  let(:square) { Square.new({col: 0}) }

  describe '#on_select' do
    it 'notifies the on_selector of the selected square' do
      subject.on_select do
        expect(true).to be_truthy
      end
      subject.select
    end
  end
end

