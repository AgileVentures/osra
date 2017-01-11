require 'rails_helper'

RSpec.describe Cashbox, type: :model do

  describe '#total' do
    context 'with existing payments' do
      it 'returns balance of cashbox' do
        cashbox_source = Cashbox.create
        cashbox_destination = Cashbox.create

        deposit_without_source = create(:payment, destination: cashbox_destination,
                                        amount: 150)
        deposit_with_source = create(:payment, destination: cashbox_destination,
                                     source: cashbox_source, amount: 100)
        withdrawal = create(:payment, amount: 50, source: cashbox_destination)


        expect(cashbox_destination.total).to eq(200)
      end
    end

    context 'without payments' do
      it 'returns zero' do
        cashbox = Cashbox.create
        expect(cashbox.total).to eq(0)
      end
    end
  end

end
