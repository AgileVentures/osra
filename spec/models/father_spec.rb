require 'rails_helper'

RSpec.describe Father, :type => :model do

  it 'should have a valid factory' do
    expect(build_stubbed :father).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_presence_of :martyr_status }

  it { is_expected.to belong_to :orphan }
  it { is_expected.to validate_presence_of :orphan_id }
  it { is_expected.to validate_uniqueness_of :orphan_id }

  describe 'validations' do
    let(:father) { build_stubbed :father, status: :alive, martyr_status: :not_martyr }

    describe '#not_martyr_if_alive' do
      context 'when father is alive' do

        it 'cannot be martyr' do
          expect{ father.martyr! }.to raise_error ActiveRecord::RecordInvalid
          expect(father.errors[:martyr_status]).to be_present
        end

        it 'can be not_martyr' do
          expect { father.not_martyr! }.not_to raise_exception
        end
      end

      context 'when father is dead' do
        before do
          father.date_of_death = 6.months.ago
          father.dead!
        end

        it 'can be martyr or not_martyr' do
          expect{ father.martyr! }.not_to raise_exception
          expect{ father.not_martyr! }.not_to raise_exception
        end
      end
    end

    describe '#no_death_details_if_alive' do
      let(:death_details) { { } }

      it 'cannot have place_of_death' do
        death_details.merge!(place_of_death: 'City Name')
        expect{ father.update!(death_details) }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'cannot have cause_of_death' do
        death_details.merge!(cause_of_death: 'Unknown')
        expect{ father.update!(death_details) }.to raise_error ActiveRecord::RecordInvalid
        end

      it 'cannot have date_of_death' do
        death_details.merge!(date_of_death: 1.month.ago)
        expect{ father.update!(death_details) }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
