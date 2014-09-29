require 'rails_helper'

describe Sponsorship, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :sponsorship).to be_valid
  end

  it { is_expected.to validate_presence_of :sponsor }
  it { is_expected.to validate_presence_of :orphan }
  it { is_expected.to belong_to :sponsor }
  it { is_expected.to belong_to :orphan }

  describe 'uniqueness validation' do
    before { create :orphan_status, name: 'Active' }
    let(:sponsor) { create :sponsor }
    let(:orphan) { create :orphan }
    subject(:sponsorship) { build :sponsorship, sponsor: sponsor, orphan: orphan }

    context 'when an active sponsorship between sponsor & orphan already exists' do
      before { sponsorship.dup.save! }
      it { is_expected.not_to be_valid }
    end

    context 'when an inactive sponsorship between sponsor & orphan exists' do
      before { create(:sponsorship, sponsorship.attributes).inactivate }
      it { is_expected.to be_valid }
    end
  end

  describe 'callbacks' do
    describe 'after_initialize #set_defaults' do
      describe 'start_date' do
        it 'defaults start_date to current date' do
          expect(Sponsorship.new.start_date).to eq Date.current
        end

        it 'sets non-default start_date if provided' do
          options = { start_date: Date.yesterday }
          expect(Sponsorship.new(options).start_date).to eq Date.yesterday
        end
      end
    end

    describe 'before_create #set_active_true' do
      before { create :orphan_status, name: 'Active' }
      let(:sponsorship) { build :sponsorship }
      it 'sets the .active attribute to true' do
        sponsorship.save!
        expect(sponsorship.reload.active).to eq true
      end
    end
  end

  describe 'methods' do
    it '.inactivate should set active = false & orphan.orphan_sponsorship_status = unsponsored' do
      create :orphan_status, name: 'Active'
      create :orphan_sponsorship_status, name: 'Unsponsored'
      sponsorship = create :sponsorship
      sponsorship.inactivate
      expect(sponsorship.reload.active).to eq false
      expect(sponsorship.orphan.reload.orphan_sponsorship_status.name).to eq 'Unsponsored'
    end
  end
end
