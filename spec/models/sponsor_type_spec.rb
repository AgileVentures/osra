require 'rails_helper'

describe SponsorType, type: :model do

  it 'should have valid fixtures' do
    SponsorType.all.each do |type|
      expect(type).to be_valid
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of :code }
end
