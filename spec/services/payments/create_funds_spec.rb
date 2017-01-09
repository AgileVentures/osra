require 'rails_helper'

module Payments
  describe CreateFunds do
    describe '.call' do
      it 'add funds to a cashbox' do
        valid_payment = Payment.new(amount: 1000)
        cashbox = Cashbox.create

        CreateFunds.call(cashbox, valid_payment)

        expect(cashbox.total).to eq(1000)

      end
    end

  end
end
