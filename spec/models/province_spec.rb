require 'rails_helper'

describe Province, type: :model do

  it 'should have valid fixtures' do
    Province.all.each do |province|
      expect(province).to be_valid
    end
  end
  
  it 'should have Province codes' do
    expect(Province::PROVINCE_CODES).to be_present
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
  
  describe 'methods & scopes' do
  
    specify '.all_names_by_code should return provinces sorted by code' do
      Province::PROVINCE_CODES.each_with_index do |code, index|
        expect(Province.all_names_by_code[index]).to eq Province.find_by_code(code).name
      end
    end
    
  end
  
end
