require 'rails_helper'

RSpec.describe Father, :type => :model do

  # subject(:father) do
  #   # (create :orphan).father
  #   build_stubbed :father
  # end

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
    let(:father) { build_stubbed :father }

    describe '#not_martyr_if_alive' do
      context 'when father is alive' do
        before do
          father.not_martyr!
          father.alive!
        end

        it 'cannot be martyr' do
          expect{ father.martyr! }.to raise_error ActiveRecord::RecordInvalid
          expect(father.errors[:martyr_status]).to be_present
        end

        it 'can be not_martyr' do
          expect { father.not_martyr! }.not_to raise_exception
        end
      end

      context 'when father is dead' do
        before { father.dead! }

        it 'can be martyr or not_martyr' do
          expect{ father.martyr! }.not_to raise_exception
          expect{ father.not_martyr! }.not_to raise_exception
        end
      end
    end

    describe '#no_death_details_if_alive' do

    end
  end
end
