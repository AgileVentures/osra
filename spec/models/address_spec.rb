require 'rails_helper'

describe Address, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :address).to be_valid
  end

  it { is_expected.to validate_presence_of :province }

  it { is_expected.to validate_presence_of :city }

  it { is_expected.to validate_presence_of :neighborhood }

  it { is_expected.to belong_to :province }
end
