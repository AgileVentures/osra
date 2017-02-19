require 'rails_helper'

describe Organization, type: :model do
  it 'should have valid fixtures' do
    Organization.all.each do |org|
      expect(org).to be_valid
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of :code }
  it { is_expected.to validate_numericality_of(:code).
    only_integer.is_greater_than_or_equal_to(50).is_less_than_or_equal_to(99).
    with_message("must be a whole number between 50 and 99") }
end
