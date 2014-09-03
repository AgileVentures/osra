require 'rails_helper'

describe Province, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :province).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of :code }
  it { is_expected.to ensure_inclusion_of(:code).in_array Province::PROVINCE_CODES }
end
