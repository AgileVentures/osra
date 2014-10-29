require 'rails_helper'

describe OrphanList, type: :model do

  let(:active_status) { Status.find_by_name 'Active' }
  let(:inactive_status) { Status.find_by_name 'Inactive' }
  let(:active_partner) { build_stubbed :partner, status: active_status }
  let(:inactive_partner) { build_stubbed :partner, status: inactive_status }

  it { is_expected.to validate_presence_of :partner }
  it { is_expected.to validate_presence_of :orphan_count }
  it { is_expected.to validate_presence_of :spreadsheet }
  it { is_expected.to belong_to :partner }
  it { is_expected.to have_many :orphans }

  it 'should not belong to a non active partner' do
    expect(build_stubbed :orphan_list, partner: inactive_partner).not_to be_valid
  end

  it 'should have a valid factory and belong to an active partner' do
    expect(build_stubbed :orphan_list, partner: active_partner).to be_valid
  end

end
