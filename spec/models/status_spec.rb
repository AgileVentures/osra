require 'rails_helper'

describe Status, type: :model do

  it 'should have valid fixtures' do
    Status.all.each do |status|
      expect(status).to be_valid
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of :code }

  describe 'methods' do
    let(:active_status) { Status.find_by_name 'Active' }
    let(:inactive_status) { Status.find_by_name 'Inactive' }

    specify "#active should return true if name == 'Active'" do
      expect(active_status.active?).to eq true
      expect(inactive_status.active?).to eq false
    end
  end
end
