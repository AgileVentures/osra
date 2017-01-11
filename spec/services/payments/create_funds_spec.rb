require 'rails_helper'

module Payments
  describe CreateFunds do
    describe '.call' do
      context 'with positive amount' do
        it 'add funds to a cashbox' do
          cashbox = Cashbox.create

          CreateFunds.call(cashbox, 1000)

          expect(cashbox.total).to eq(1000)
        end

        it 'returns true' do
          cashbox = Cashbox.create

          res = CreateFunds.call(cashbox, 1000)

          expect(res).to be_truthy
        end
      end

      context 'with negative amount' do
        it 'returns false' do
          cashbox = Cashbox.create

          res = CreateFunds.call(cashbox, -1000)

          expect(res).to be_falsey
        end
        
      end
    end

  end
end
