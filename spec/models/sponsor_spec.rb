require 'rails_helper'

describe Sponsor, type: :model do
  let(:active_status) { Status.find_by_name 'Active' }
  let(:inactive_status) { Status.find_by_name 'Inactive' }
  let(:on_hold_status) { Status.find_by_name 'On Hold' }

  let(:individual_type) { SponsorType.find_by_name 'Individual' }
  let(:organization_type) { SponsorType.find_by_name 'Organization' }

  it 'should have a valid factory' do
    expect(build_stubbed :sponsor).to be_valid
  end

  it 'should have payment plans' do
    expect(Sponsor::PAYMENT_PLANS).to be_present
  end

  it { is_expected.to belong_to :branch }
  it { is_expected.to belong_to :organization }
  it { is_expected.to belong_to :status }
  it { is_expected.to belong_to :sponsor_type }
  it { is_expected.to have_many(:orphans).through :sponsorships }
  it { is_expected.to belong_to :agent }
  it { is_expected.to have_one :cashbox }

  describe "validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :requested_orphan_count }
    it { is_expected.to validate_presence_of :country }
    it { is_expected.to validate_presence_of :city }
    it { is_expected.not_to allow_value(Sponsor::NEW_CITY_MENU_OPTION).for(:city).
                                with_message 'Please enter city name below. &darr;' }
    it { is_expected.to validate_presence_of :sponsor_type }
    it { is_expected.to validate_presence_of :agent }

    it { is_expected.to validate_presence_of :gender }
    it { is_expected.to validate_presence_of :status_id }
    it { is_expected.to validate_inclusion_of(:gender).in_array Settings.lookup.gender }
    it { is_expected.to validate_inclusion_of(:payment_plan).in_array (Sponsor::PAYMENT_PLANS << '') }
    it { is_expected.to validate_inclusion_of(:country).in_array ISO3166::Country.countries.map { |c| c[1] } - ['IL'] }


    it { is_expected.to validate_numericality_of(:requested_orphan_count).
                            only_integer.is_greater_than(0) }

    context "requested_orphan_count_not_less_than_active_sponsorships_count" do
      let(:sponsor) { build_stubbed :sponsor, requested_orphan_count: 4 }

      before :each do
        2.times do
          sponsorship = build :sponsorship, sponsor: sponsor
          CreateSponsorship.new(sponsorship).call
        end
      end

      it "requested_orphan_count can't be less than the number of active sponsorships" do
        sponsor.requested_orphan_count = 1
        expect(sponsor).to_not be_valid
        expect(sponsor.errors.full_messages).to_not be_empty
      end

      it "requested_orphan_count can be greather or equal than the number of active sponsorships" do
        [2,3].each do |count|
          sponsor.requested_orphan_count = count
          expect(sponsor).to be_valid
          expect(sponsor.errors.full_messages).to be_empty
        end
      end
    end

    context 'start_date' do
      it { is_expected.to have_validation :valid_date_presence, :on => :start_date }
      it { is_expected.to have_validation :date_beyond_osra_establishment, :on => :start_date }
      it { is_expected.to have_validation :date_not_beyond_first_of_next_month, :on => :start_date }
    end

    context 'email' do
      it { is_expected.to allow_value(nil, '', 'admin@example.com', 'some.email@192.168.100.100', 'grüner@grü.üne',
          'تللتنمي@تنمي.نمي', 'لتتت@تمت.متت', 'あいうえお@うえ.いえ', "+valid@email.com").for :email }
      ['not_email', 'also@not_email', 'really_not@', 'not_emal@em..com', '"not@an.em'].each do |bad_email_value|
        it { is_expected.to_not allow_value(bad_email_value).for :email }
      end
    end
  end

  describe '.request_fulfilled' do
    let(:sponsor) { build(:sponsor, requested_orphan_count: 2) }

    it 'should default to request unfulfilled' do
      sponsor.save!
      expect(sponsor.request_fulfilled?).to be false
    end

    it 'should make request unfulfilled on create always' do
      sponsor.request_fulfilled = true
      sponsor.save!
      expect(sponsor.reload.request_fulfilled?).to be false
    end

    it 'should allow existing records to have request_fulfilled' do
      sponsor.save!
      allow(sponsor).to receive_message_chain(:sponsorships, :all_active, :size).and_return 1
      sponsor.requested_orphan_count = 1
      sponsor.save!
      expect(sponsor.reload.request_fulfilled?).to be true
    end
  end

  describe 'branch or organization affiliation' do
    let(:branch) { Branch.all.sample }
    let(:organization) { Organization.all.sample }

    describe 'must be affiliated to 1 branch or 1 organization' do
      subject(:sponsor) { build_stubbed(:sponsor) }

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
          sponsor.sponsor_type = individual_type
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
          sponsor.sponsor_type = organization_type
        end

        it { is_expected.to be_valid }
        it 'returns branch name as affiliate' do
          expect(sponsor.affiliate).to eq organization.name
        end
      end
    end

    describe 'SponsorType must match affiliation' do
      let(:sponsor) { build :sponsor, sponsor_type: individual_type }

      context 'when SponsorType matches affiliation' do
        specify 'Individual type and Branch affiliation are valid' do
          sponsor.sponsor_type = individual_type
          sponsor.branch = branch
          sponsor.organization = nil
          expect(sponsor).to be_valid
        end

        specify 'Organization type and Organization affiliation are valid' do
          sponsor.sponsor_type = organization_type
          sponsor.organization = organization
          sponsor.branch = nil
          expect(sponsor).to be_valid
        end
      end

      context 'when SponsorType does not match affiliation' do
        specify 'Individual type and Organization affiliation are not valid' do
          sponsor.sponsor_type = individual_type
          sponsor.organization = organization
          sponsor.branch = nil
          expect(sponsor).not_to be_valid
        end

        specify 'Organization type and Branch affiliation are not valid' do
          sponsor.sponsor_type = organization_type
          sponsor.branch = branch
          sponsor.organization = nil
          expect(sponsor).not_to be_valid
        end
      end

      describe 'should not be able to change affiliation-related info for persisted sponsors' do
        let(:organization) { Organization.all.sample }

        before { sponsor.save! }

        it 'should not update affiliation or SponsorType' do
          sponsor.update!(branch: nil, organization: organization, sponsor_type: organization_type)
          sponsor.reload
          expect(sponsor.branch).not_to be_nil
          expect(sponsor.organization).to be_nil
          expect(sponsor.sponsor_type.name).to eq 'Individual'
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'after_initialize #set_defaults' do
      describe 'status' do

        it 'defaults status to "Active"' do
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
          sponsorship = build :sponsorship, sponsor: sponsor
          CreateSponsorship.new(sponsorship).call
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

    describe 'before_create #generate_osra_num' do
      let(:branch) { Branch.all.sample }
      let(:organization) { Organization.all.sample }

      let(:sponsor) { build :sponsor, :organization => nil, :branch => nil }

      it 'sets osra_num' do
        sponsor.branch = branch
        sponsor.sponsor_type = individual_type
        sponsor.save!
        expect(sponsor.osra_num).not_to be_nil
      end

      describe 'when recruited by osra branch' do
        before(:each) do
          sponsor.branch = branch
          sponsor.sponsor_type = individual_type
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
          sponsor.sponsor_type = organization_type
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
        sponsor.sponsor_type = individual_type
        sponsor.sequential_id = 999
        sponsor.save!
        expect(sponsor.osra_num[3..-1]).to eq '0999'
      end
    end

    describe 'before_validation #set_city' do
      let(:sponsor) { create :sponsor, city: 'London' }

      before do
        sponsor.city = Sponsor::NEW_CITY_MENU_OPTION
      end

      it 'sets city to new name' do
        sponsor.new_city_name = 'Riyadh'
        sponsor.save!
        expect(sponsor.city).to eq 'Riyadh'
      end

      it 'raises an error if **Add New** is given as city without new_city_name' do
        expect { sponsor.save! }.to raise_error ActiveRecord::RecordInvalid
      end
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

    describe '#currently_sponsored_orphans' do
      let(:new_sponsor) { build_stubbed :sponsor, requested_orphan_count: 5 }
      let(:current_orphan) { create :orphan }
      let(:past_orphan) { create :orphan }
      let!(:current_sponsorship) { create :sponsorship,
                                                sponsor: new_sponsor,
                                                orphan: current_orphan }
      let!(:past_sponsorship) { create :sponsorship,
                                             sponsor: new_sponsor,
                                             orphan: past_orphan }

      before(:each) do
        future_date = past_sponsorship.start_date + 1.month
        InactivateSponsorship.new(sponsorship: past_sponsorship,
                                  end_date: future_date).call
      end

      it 'returns only orphans that are currently sponsored' do
        expect(new_sponsor.currently_sponsored_orphans).to match_array [current_orphan]
      end

      describe '#to_csv' do
        let!(:sponsor_no_request) {build(:sponsor, name: 'John Doe', gender: 'Male', requested_orphan_count: 4, active_sponsorship_count: 1, request_fulfilled: false)}
        let!(:sponsor_with_request) {build(:sponsor, name: 'John Doe', gender: 'Male', requested_orphan_count: 4, active_sponsorship_count: 1, request_fulfilled: true)}
        context 'with negative request fufilled description' do
          it 'generates csv content for given sponsors' do
            output = "Osra Num,Name,Status,Start Date,Request Fulfilled,Sponsor Type,Country\n," + 
              ["John Doe","#{sponsor_no_request.status.name}","#{sponsor_no_request.start_date}","No (1/4)","#{sponsor_no_request.sponsor_type.name}","#{en_ar_country(sponsor_no_request.country)}"].to_csv
            expect(Sponsor.to_csv([sponsor_no_request])).to eq(output)

          end
        end

        context 'with request fufilled description' do
          it 'generates csv content for given sponsors' do
            output = "Osra Num,Name,Status,Start Date,Request Fulfilled,Sponsor Type,Country\n," + 
              ["John Doe","#{sponsor_with_request.status.name}","#{sponsor_with_request.start_date}","Yes (1/4)","#{sponsor_with_request.sponsor_type.name}","#{en_ar_country(sponsor_with_request.country)}"].to_csv
            expect(Sponsor.to_csv([sponsor_with_request])).to eq(output)

          end
        end
      end
    end

    describe '.all_cities' do
      before do
        2.times { create :sponsor, city: 'London' }
        create :sponsor, city: 'Toronto'
      end

      it 'returns all unique city names' do
        expect(Sponsor.all_cities).to match_array %w{London Toronto}
      end
    end

    describe 'scopes' do
      let(:sponsor) { create :sponsor }
      let(:active_sponsor) { create :sponsor, status: active_status }
      let(:inactive_sponsor) { create :sponsor, status: inactive_status }
      let(:on_hold_sponsor) { create :sponsor, status: on_hold_status }

      specify '.all_active should return sponsors with statuses Active & On Hold only' do
        expect(Sponsor.all_active).to match_array [active_sponsor, on_hold_sponsor]
      end

      specify '.all_inactive should return sponsors with Inactive status only' do
        expect(Sponsor.all_inactive).to match_array [inactive_sponsor]
      end

      specify '.filter' do
        expect(Sponsor.methods.include? :filter).to be true
      end
    end
  end

end
