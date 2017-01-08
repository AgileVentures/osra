require 'rails_helper'

RSpec.describe Cashbox, type: :model do

  describe '#total' do
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
end
