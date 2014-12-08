require 'rails_helper'

describe Branch, type: :model do

  it 'should have valid fixtures' do
    Branch.all.each do |branch|
      expect(branch).to be_valid
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_numericality_of(:code).only_integer }
  it { is_expected.to validate_inclusion_of(:code).in_range 0..99 }
  it { is_expected.to validate_uniqueness_of(:code) }

  end
