require 'rails_helper'

describe Integer do

  context 'parity' do
    example 'is even' do
      expect(8.parity).to eq 'even'
      expect(0.parity).to eq 'even'
      expect(-13.next.parity).to eq 'even'
    end

    example 'is odd' do
      expect(7.parity).to eq 'odd'
      expect(-9.parity).to eq 'odd'
    end
  end
end
