require 'rails_helper'

RSpec.describe Father, :type => :model do

  subject(:father) do
    (create :orphan).father
  end

  it 'should have a valid factory' do
    # expect(create :father).to be_valid
    # expect(build :father).to be_valid
    # expect(build_stubbed :father).to be_valid
    #
    # expect{ build :father }.not_to change(Orphan, :count)
    # expect{ build_stubbed :father }.not_to change(Orphan, :count)
    # expect{ create :father }.to change(Orphan, :count).by 1
    expect(father).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_presence_of :martyr_status }

  it { is_expected.to belong_to :orphan }
  it { is_expected.to validate_presence_of :orphan_id }
end
