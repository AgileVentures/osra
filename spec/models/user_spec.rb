require 'rails_helper'

RSpec.describe User, :type => :model do

  it 'should have a valid factory' do
    expect(build_stubbed :user).to be_valid
  end

  it { is_expected.to validate_presence_of :user_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :user_name }
  it { is_expected.to validate_uniqueness_of :email }

  [nil, '', 'not_an_email@'].each do |bad_email|
    it { is_expected.not_to allow_value(bad_email).for :email }
  end

  it { is_expected.to have_many :sponsors }

  it 'should override the default pagination per_page' do
    expect(User.per_page).to eq 10
  end

  describe 'methods' do
    let(:user) { build_stubbed :user }
    let(:active_status) { Status.find_by_name 'Active' }
    let(:inactive_status) { Status.find_by_name 'Inactive' }
    let(:active_sponsor) { create :sponsor, agent: user, status: active_status }
    let(:inactive_sponsor) { create :sponsor, agent: user, status: inactive_status }

    specify '#active_sponsors returns active sponsors only' do
      expect(user.active_sponsors).to match_array [active_sponsor]
    end

    specify '#inactive_sponsors returns inactive sponsors only' do
      expect(user.inactive_sponsors).to match_array [inactive_sponsor]
    end
  end
end
