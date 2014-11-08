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
end
