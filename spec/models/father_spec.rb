require 'rails_helper'

RSpec.describe Father, :type => :model do

  it 'should have a vaild factory' do
    # expect(build_stubbed :father).to be_valid
    10.times { puts build_stubbed(:father).inspect }
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_presence_of :martyr_status }

  it { is_expected.to have_many :orphans }
end
