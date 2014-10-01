require 'rails_helper'

describe Status, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :status).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of :code }

  describe 'methods' do
    let(:active_status) { build_stubbed :status, name: 'Active' }
    let(:inactive_status) { build_stubbed :status, name: 'Inactive' }

    specify "#active should return true if name == 'Active'" do
      expect(active_status.active?).to eq true
      expect(inactive_status.active?).to eq false
    end
  end
end
