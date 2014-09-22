require 'rails_helper'

describe Sponsor, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :sponsor).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :country }
  it { is_expected.to validate_presence_of :sponsor_type }

  it { is_expected.to ensure_inclusion_of(:gender).in_array %w(Male Female) }

  it { is_expected.to allow_value(Date.current, Date.yesterday).for :start_date }
  it { is_expected.not_to allow_value(Date.tomorrow).for :start_date }
  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :start_date }
  end

  it { is_expected.to belong_to :branch }
  it { is_expected.to belong_to :organization }
  it { is_expected.to belong_to :status }
  it { is_expected.to belong_to :sponsor_type }
  it { is_expected.to have_many(:orphans).through :sponsorships }

  describe 'branch or organization affiliation' do
    describe 'must be affiliated to 1 branch or 1 organization' do
      let(:sponsor) {build_stubbed(:sponsor, :organization_id => nil, :branch_id => nil)}
      let(:organization) {build_stubbed(:organization)}
      let(:branch) {build_stubbed(:branch)}
      it 'cannot be unaffiliated' do
        expect(sponsor).to_not allow_value(nil).for :organization
        expect(sponsor).to_not allow_value(nil).for :branch
      end
      it 'cannot be affiliated to a branch and an organisation' do
        sponsor.branch = branch
        sponsor.organization = organization
        expect(sponsor).to_not allow_value(organization).for :organization
        expect(sponsor).to_not allow_value(branch).for :branch
      end
      it 'is valid when affiliated with a branch' do
        sponsor.organization = organization
        expect(sponsor).to allow_value(organization).for :organization
      end
      it 'is valid when affiliated with an organization' do
        sponsor.branch = branch
        expect(sponsor).to allow_value(branch).for :branch
      end
    end
  end

  describe 'callbacks' do
    describe 'after_initialize #set_defaults' do
      describe 'status' do
        let!(:under_revision_status) { create :status, name: 'Under Revision' }
        let(:active_status) { build_stubbed :status, name: 'Active' }

        it 'defaults status to "Under Revision"' do
          expect((Sponsor.new).status).to eq under_revision_status
        end

        it 'sets non-default status if provided' do
          options = { status: active_status }
          expect(Sponsor.new(options).status).to eq active_status
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
    end
  end

  describe 'before_create #generate_osra_num' do
    let(:sponsor) { build :sponsor }

    it 'sets osra_num' do
      sponsor.save!
      expect(sponsor.osra_num).not_to be_nil
    end

    describe 'when recruited by osra' do
      it 'sets the first digit to 5' do
        sponsor.save!
        expect(sponsor.osra_num[0...1]).to eq "5"
      end

      it 'sets the second and third digit to the branch code' do
        branch = build_stubbed(:branch)
        sponsor.branch = branch
        sponsor.save!
        expect(sponsor.osra_num[1...3]).to eq "%02d" % branch.code
      end
    end

    describe 'when recruited by a sister organization' do
      it 'sets the first digit to an 8 ' do
        organization = build_stubbed(:organization)
        sponsor.organization = organization
        sponsor.branch = nil
        sponsor.save!
        sponsor
        expect(sponsor.osra_num[0...1]).to eq "8"
      end

      it 'sets the second and third digit to the organization code' do
        organization = build_stubbed(:organization)
        sponsor.organization = organization
        sponsor.branch = nil
        sponsor.save!
        expect(sponsor.osra_num[1...3]).to eq "%02d" % organization.code
      end
    end

    it 'sets the last 4 digits of osra_num to sequential_id' do
      sponsor.sequential_id = 999
      sponsor.save!
      expect(sponsor.osra_num[3..-1]).to eq '0999'
    end
  end
end
