require 'rails_helper'

describe OrphanList, type: :model do

  let(:orphan_list) { build_stubbed(:orphan_list) }

  it 'should have a valid factory' do
    orphan_list.partner.status = Status.find_or_create_by(name: 'Active', code: 1)
    expect(orphan_list).to be_valid
  end

  it { is_expected.to validate_presence_of :partner }
  it { is_expected.to validate_presence_of :orphan_count }
  it { is_expected.to validate_presence_of :spreadsheet }

  it 'should not belong to a non active partner' do
    orphan_list.partner.status = Status.find_or_create_by(name: 'Inactive', code: 2)
    expect(orphan_list).to_not be_valid
  end

  it 'should belong to an active partner' do
    orphan_list.partner.status = Status.find_or_create_by(name: 'Active', code: 1)
    expect(orphan_list).to be_valid
  end

  it { is_expected.to belong_to :partner }
end