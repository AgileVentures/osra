require 'rails_helper'

describe Organization, type: :model do

  it 'should have valid fixtures' do
    Organization.all.each do |org|
      expect(org).to be_valid
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of :code }
end
