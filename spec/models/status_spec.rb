require 'rails_helper'

describe Status, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :status).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of :code }
end
