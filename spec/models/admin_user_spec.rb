require 'rails_helper'

RSpec.describe AdminUser, :type => :model do

  it 'should have a valid factory' do
    expect(build_stubbed :admin_user).to be_valid
  end

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.not_to validate_presence_of :password_confirmation }
  it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.not_to validate_uniqueness_of :password }
  it { is_expected.not_to validate_uniqueness_of :password_confirmation }

  [nil, '', 'not_an_email@'].each do |bad_email|
    it { is_expected.not_to allow_value(bad_email).for :email }
  end

  [nil, '', 'short'].each do |bad_password|
    it { is_expected.not_to allow_value(bad_password).for :password }
  end

  ['', 'short'].each do |bad_password_confirmation|
    it { is_expected.not_to allow_value(bad_password_confirmation).for :password_confirmation }
  end

end
