require 'rails_helper'

RSpec.describe Father, :type => :model do

  it 'should have a vaild factory' do
    expect(build_stubbed :father).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_exclusion_of(:is_alive?).in_array [nil] }

  it { is_expected.to have_many :orphans }
end
