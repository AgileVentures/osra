require 'rails_helper'

describe Orphan, type: :model do
  let!(:active_orphan_status) { create :orphan_status, name: 'Active' }
  let!(:inactive_orphan_status) { create :orphan_status, name: 'Inactive' }
  let!(:active_status) { create :status, name: 'Active' }
  let!(:sponsored_status) { create :orphan_sponsorship_status, name: 'Sponsored' }
  let!(:unsponsored_status) { create :orphan_sponsorship_status, name: 'Unsponsored' }

  it 'should have a valid factory' do
    expect(build_stubbed :orphan).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :father_name }
  it { is_expected.to_not allow_value(nil).for(:father_is_martyr) }

  it { is_expected.to validate_presence_of :father_date_of_death }
  it { is_expected.to allow_value(Date.today - 5, Date.current).for(:father_date_of_death) }
  it { is_expected.to_not allow_value(Date.today + 5).for(:father_date_of_death) }
  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :father_date_of_death }
  end

  it { is_expected.to validate_presence_of :mother_name }
  it { is_expected.to_not allow_value(nil).for(:mother_alive) }

  it { is_expected.to allow_value(Date.today - 5, Date.current).for(:date_of_birth) }
  it { is_expected.to_not allow_value(Date.today + 5).for(:date_of_birth) }
  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :date_of_birth }
  end

  it { is_expected.to validate_presence_of :gender }
  it { is_expected.to validate_inclusion_of(:gender).in_array %w(Male Female) }

  it { is_expected.to validate_presence_of :contact_number }

  it { is_expected.to_not allow_value(nil).for(:sponsored_by_another_org) }

  it { is_expected.to validate_numericality_of(:minor_siblings_count).only_integer.is_greater_than_or_equal_to(0) }

  it { is_expected.to validate_presence_of :original_address }
  it { is_expected.to validate_presence_of :current_address }
  it { is_expected.to have_one(:original_address).class_name 'Address' }
  it { is_expected.to have_one(:current_address).class_name 'Address' }
  it { is_expected.to accept_nested_attributes_for :original_address }
  it { is_expected.to accept_nested_attributes_for :current_address }

  it { is_expected.to belong_to :orphan_status }
  it { is_expected.to belong_to :orphan_sponsorship_status }
  it { is_expected.to belong_to :orphan_list }
  it { is_expected.to validate_presence_of :orphan_status }
  it { is_expected.to validate_presence_of :priority }
  it { is_expected.to validate_inclusion_of(:priority).in_array %w(Normal High) }
  it { is_expected.to validate_presence_of :orphan_sponsorship_status }
  it { is_expected.to validate_presence_of :orphan_list }

  it { is_expected.to have_many :sponsorships }
  it { is_expected.to have_many(:sponsors).through :sponsorships }

  describe '#orphans_dob_within_1yr_of_fathers_death' do
    let(:orphan) { create :orphan, :father_date_of_death => (1.year + 1.day).ago }

    it "is valid when orphan is born a year after fathers death" do
      orphan.date_of_birth = 1.day.ago
      expect(orphan).to be_valid
    end

    it "is not valid when orphan is born more than a year after fathers death" do
      orphan.date_of_birth = Date.current
      expect(orphan).not_to be_valid
    end
  end

  describe 'initializers, methods & scopes' do
    describe 'initializers' do

      it 'defaults orphan_status to Active' do
        expect(Orphan.new.orphan_status).to eq active_orphan_status
      end

      it 'defaults orphan_sponsorship_status to Unsponsored' do
        expect(Orphan.new.orphan_sponsorship_status).to eq unsponsored_status
      end

      it 'defaults priority to Normal' do
        expect(Orphan.new.priority).to eq 'Normal'
      end
    end

    describe 'methods & scopes' do
      let!(:active_unsponsored_orphan) do
        create :orphan,
               orphan_status: active_orphan_status,
               orphan_sponsorship_status: unsponsored_status
      end
      let!(:inactive_unsponsored_orphan) do
        create :orphan,
               orphan_status: inactive_orphan_status,
               orphan_sponsorship_status: unsponsored_status
      end
      let!(:active_sponsored_orphan) do
        create :orphan,
               orphan_status: active_orphan_status,
               orphan_sponsorship_status: sponsored_status
      end

      let!(:high_priority_orphan) { create :orphan, priority: 'High' }

      describe 'methods' do
        it '#set_status_to_sponsored' do
          orphan = active_unsponsored_orphan
          orphan.set_status_to_sponsored
          expect(orphan.reload.orphan_sponsorship_status).to eq sponsored_status
        end

        it '#set_status_to_unsponsored' do
          orphan = active_sponsored_orphan
          orphan.set_status_to_unsponsored
          expect(orphan.reload.orphan_sponsorship_status).to eq unsponsored_status
        end
      end

      describe 'scopes' do

        specify '.active should correctly select active orphans only' do
          expect(Orphan.active.to_a).to match_array [active_sponsored_orphan,
                                            active_unsponsored_orphan,
                                            high_priority_orphan]
        end

        specify '.unsponsored should correctly select unsponsored orphans only' do
          expect(Orphan.unsponsored.to_a).to match_array [active_unsponsored_orphan,
                                                 inactive_unsponsored_orphan,
                                                 high_priority_orphan]
        end

        specify '.active.unsponsored should correctly return active unsponsored orphans only' do
          expect(Orphan.active.unsponsored.to_a).to match_array [active_unsponsored_orphan,
                                                        high_priority_orphan]
        end

        specify '.high_priority should correctly return high-priority orphans' do
          expect(Orphan.high_priority.to_a).to eq [high_priority_orphan]
        end
      end
    end
  end
end
