require 'rails_helper'

describe OrphanStatus, type: :model do

  # it 'should have a valid factory' do
  #   expect(build_stubbed :orphan_status).to be_valid
  # end

  it 'should have valid fixtures' do
    OrphanStatus.all.each do |orphan_status|
      expect(orphan_status).to be_valid
    end
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of :code }
end
