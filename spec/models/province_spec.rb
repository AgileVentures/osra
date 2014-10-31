require 'rails_helper'

describe Province, type: :model do

  # it 'should have a valid factory' do
  #   expect(build_stubbed :province).to be_valid
  # end

  it 'should have valid fixtures' do
    Province.all.each do |province|
      expect(province).to be_valid
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of :code }

  describe 'code value validation' do
    # to prevent codes being tested from running into uniqueness
    # constraints with persisted provinces from fixture
    before { Province.destroy_all }

    it { is_expected.to validate_inclusion_of(:code).in_array Province::PROVINCE_CODES }
  end
end
