require 'rails_helper'

describe Sponsor, type: :model do
  let(:active_status) { Status.find_by_name 'Active' }
  let(:inactive_status) { Status.find_by_name 'Inactive' }
  let(:on_hold_status) { Status.find_by_name 'On Hold' }

  let!(:individual_type) { create :sponsor_type, name: 'Individual' }
  let(:organization_type) { create :sponsor_type, name: 'Organization' }

  it 'should have a valid factory' do
    expect(build_stubbed :sponsor).to be_valid
  end
  
  #it 'should have payment plans' do
  #  expect(Sponsor.payment_plans).to be_truthy
  #end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :requested_orphan_count }
  it { is_expected.to validate_presence_of :country }
  it { is_expected.to validate_presence_of :sponsor_type }

  it { is_expected.to validate_inclusion_of(:gender).in_array %w(Male Female) }
  it { is_expected.to validate_inclusion_of(:country).in_array ISO3166::Country.countries.map {|c| c[1]} - ['IL']}

  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :start_date }
  end

  it { is_expected.to validate_numericality_of(:requested_orphan_count).
     only_integer.is_greater_than(0) }

  it { is_expected.to belong_to :branch }
  it { is_expected.to belong_to :organization }
  it { is_expected.to belong_to :status }
  it { is_expected.to belong_to :sponsor_type }
  it { is_expected.to have_many(:orphans).through :sponsorships }
  it { is_expected.to validate_inclusion_of(:payment_plan).in_array
            ['', 'Monthly', 'Every Two Months', 'Every Four Months', 'Every Six Months', 'Annually', 'Other'] }

  context 'start_date validation on or before 1st of next month' do
    today = Date.current
    first_of_next_month = today.beginning_of_month.next_month
    yesterday = today.yesterday
    second_of_next_month = first_of_next_month + 1.day
    two_months_ahead = today + 2.months

    [today, first_of_next_month, yesterday].each do |good_date|
      it { is_expected.to allow_value(good_date).for :start_date }
    end

    [second_of_next_month, two_months_ahead].each do |bad_date|
      it { is_expected.to_not allow_value(bad_date).for :start_date }
    end
  end

  describe '.request_fulfilled' do
    let(:sponsor) { build(:sponsor, requested_orphan_count: 2) }

    it 'should default to  request unfulfilled'  do
      sponsor.save!
      expect(sponsor.request_fulfilled?).to be false
    end

    it 'should make request unfulfilled on create always'  do
      sponsor.request_fulfilled = true
      sponsor.save!
      expect(sponsor.reload.request_fulfilled?).to be false
    end

    it 'should allow exisitng records to have request_fulfilled' do
      sponsor.save!
      expect(sponsor).to receive(:request_is_fulfilled?).and_return true
      sponsor.save!
      expect(sponsor.reload.request_fulfilled?).to be true
    end
  end

  describe 'branch or organization affiliation' do
    describe 'must be affiliated to 1 branch or 1 organization' do
      subject(:sponsor) { build_stubbed(:sponsor) }
      let(:organization) { build_stubbed(:organization) }
      let(:branch) { build_stubbed(:branch) }

      it 'cannot be unaffiliated' do
        sponsor.organization, sponsor.branch = nil
        expect(sponsor).not_to be_valid
      end
      it 'cannot be affiliated to a branch and an organisation' do
        sponsor.branch = branch
        sponsor.organization = organization
        expect(sponsor).not_to be_valid
      end
      context 'when affiliated with a branch but not an organization' do
        before do
          sponsor.branch = branch
          sponsor.organization = nil
        end

        it { is_expected.to be_valid }
        it 'returns branch name as affiliate' do
          expect(sponsor.affiliate).to eq branch.name
        end
      end

      context 'when affiliated with an organization but not a branch' do
        before do
          sponsor.branch = nil
          sponsor.organization = organization
        end

        it { is_expected.to be_valid }
        it 'returns branch name as affiliate' do
          expect(sponsor.affiliate).to eq organization.name
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'after_initialize #set_defaults' do
      describe 'status' do

        it 'defaults status to "Under Revision"' do
          expect((Sponsor.new).status).to eq active_status
        end

        it 'sets non-default status if provided' do
          options = { status: on_hold_status }
          expect(Sponsor.new(options).status).to eq on_hold_status
        end
      end

      describe 'start_date' do
        it 'defaults start_date to current date' do
          expect(Sponsor.new.start_date).to eq Date.current
        end

        it 'sets non-default start_date if provided' do
          options = { start_date: Date.yesterday }
          expect(Sponsor.new(options).start_date).to eq Date.yesterday
        end
      end

      describe 'sponsor_type' do
        it 'defaults sponsor_type to Individual' do
          expect(Sponsor.new.sponsor_type).to eq individual_type
        end

        it 'sets non-default sponsor_type if provided' do
          expect(Sponsor.new(sponsor_type: organization_type).sponsor_type).to eq organization_type
        end
      end
    end

    describe 'before_update #validate_inactivation' do
      let(:sponsor) { create :sponsor }

      context 'when sponsor has no active sponsorships' do
        specify 's/he can be inactivated' do
          expect{ sponsor.update!(status: inactive_status) }.not_to raise_exception
        end
      end

      context 'when sponsor has active sponsorships' do
        before do
          orphan = create(:orphan)
          create :sponsorship, sponsor: sponsor, orphan: orphan
        end

        specify 's/he cannot be inactivated' do
          expect{ sponsor.update!(status: inactive_status) }.to raise_error ActiveRecord::RecordInvalid
          expect(sponsor.errors[:status]).to include 'Cannot inactivate sponsor with active sponsorships'
        end

        specify 's/he can be placed On Hold' do
          expect{ sponsor.update!(status: on_hold_status) }.not_to raise_exception
        end
      end
    end
  end

  describe 'before_create #generate_osra_num' do
    let(:branch) { build_stubbed :branch }
    let(:organization) { build_stubbed :organization }
    let(:sponsor) { build :sponsor, :organization => nil, :branch => nil }

    it 'sets osra_num' do
      sponsor.branch = branch
      sponsor.save!
      expect(sponsor.osra_num).not_to be_nil
    end

    describe 'when recruited by osra branch' do
      before(:each) do
        sponsor.branch = branch
        sponsor.save!
      end

      it 'sets the first digit to 5' do
        expect(sponsor.osra_num[0]).to eq "5"
      end

      it 'sets the second and third digits to the branch code' do
        expect(sponsor.osra_num[1...3]).to eq "%02d" % branch.code
      end
    end

    describe 'when recruited by a sister organization' do
      before(:each) do
        sponsor.organization = organization
        sponsor.save!
      end

      it 'sets the first digit to an 8 ' do
        expect(sponsor.osra_num[0]).to eq "8"
      end

      it 'sets the second and third digits to the organization code' do
        expect(sponsor.osra_num[1...3]).to eq "%02d" % organization.code
      end
    end

    it 'sets the last 4 digits of osra_num to sequential_id' do
      sponsor.branch = branch
      sponsor.sequential_id = 999
      sponsor.save!
      expect(sponsor.osra_num[3..-1]).to eq '0999'
    end
  end

  describe 'methods' do
    let(:active_sponsor) { build_stubbed :sponsor }
    let(:on_hold_sponsor) { build_stubbed :sponsor, status: on_hold_status }
    let(:request_fulfilled_sponsor) { build_stubbed :sponsor, request_fulfilled: true }

    specify '#eligible_for_sponsorship? should return true for eligible sponsors' do
      expect(active_sponsor.eligible_for_sponsorship?).to eq true
      expect(on_hold_sponsor.eligible_for_sponsorship?).to eq false
      expect(request_fulfilled_sponsor.eligible_for_sponsorship?).to eq false
    end

    describe 'sponsorship requests' do
      describe '#request_is_fulfilled?' do
        it 'should return false if number of active sponsorships is less than requested' do
          expect(active_sponsor).to receive(:requested_orphan_count).and_return 5
          expect(active_sponsor).to receive_message_chain(:sponsorships, :all_active, :count).and_return 3
          expect(active_sponsor.send(:request_is_fulfilled?)).to be false
        end

        it 'should return true if number of active sponsorships is equal to requested' do
          expect(active_sponsor).to receive(:requested_orphan_count).and_return 5
          expect(active_sponsor).to receive_message_chain(:sponsorships, :all_active, :count).and_return 5
          expect(active_sponsor.send(:request_is_fulfilled?)).to be true
        end
      end

      describe '#set_request_fulfilled' do
        let(:in_memory_sponsor) { Sponsor.new }

        it 'should set request_fulfilled to true when requests have been fulfilled' do
          in_memory_sponsor.request_fulfilled = false
          expect(in_memory_sponsor).to receive(:request_is_fulfilled?).and_return true
          expect{ in_memory_sponsor.send(:set_request_fulfilled) }.to change{ in_memory_sponsor.request_fulfilled }.from(false).to(true)
        end

        it 'should set request_fulfilled to false when requests have not been fulfilled' do
          in_memory_sponsor.request_fulfilled = true
          expect(in_memory_sponsor).to receive(:request_is_fulfilled?).and_return false
          expect{ in_memory_sponsor.send(:set_request_fulfilled) }.to change{ in_memory_sponsor.request_fulfilled }.from(true).to(false)
        end
      end

      describe '#update_request_fulfilled!' do
        let(:persisted_sponsor) { create :sponsor }

        it 'should set request_fulfilled to true when requests have been fulfilled' do
          persisted_sponsor.update_columns(request_fulfilled: false)
          allow(persisted_sponsor).to receive(:request_is_fulfilled?).and_return true
          expect{ persisted_sponsor.update_request_fulfilled! }.to \
            change{ persisted_sponsor.reload.request_fulfilled }.from(false).to(true)
        end

        it 'should set request_fulfilled to false when requests have not been fulfilled' do
          persisted_sponsor.update_columns(request_fulfilled: true)
          allow(persisted_sponsor).to receive(:request_is_fulfilled?).and_return false
          expect{ persisted_sponsor.update_request_fulfilled! }.to \
            change{ persisted_sponsor.reload.request_fulfilled }.from(true).to(false)
        end
      end
    end
  end
end
