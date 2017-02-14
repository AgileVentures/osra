require 'rails_helper'

RSpec.describe Cashbox, type: :model do

  describe '#total' do
    context 'with existing payments' do
      it 'returns balance of cashbox' do
        destination_cashbox = Cashbox.create
        amount_1 = FactoryHelper::MySQL.int(min: 1, max: 2147483647)
        amount_2 = FactoryHelper::MySQL.int(min: 1, max: 2147483647)
        build_payment_from_outside(destination_cashbox, amount_2)
        build_payment_from_cashbox(destination_cashbox, amount_1)

        expect(destination_cashbox.total).to eq(amount_1 + amount_2)
      end
    end

    context 'without payments' do
      it 'returns zero' do
        cashbox = Cashbox.create
        expect(cashbox.total).to eq(0)
      end
    end
  end

  def build_payment_from_cashbox(destination_cashbox, amount)
    cashbox_source = Cashbox.create
    create(:payment, destination: destination_cashbox, source: cashbox_source,
           amount: amount)
  end

  def build_payment_from_outside(destination_cashbox, amount)
    create(:payment, destination: destination_cashbox, amount: amount)
  end
end
