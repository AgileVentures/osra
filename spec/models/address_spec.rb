require 'rails_helper'

RSpec.describe Address, :type => :model do

  it { is_expected.to validate_presence_of :province }

  it { is_expected.to validate_presence_of :city }

  it { is_expected.to validate_presence_of :neighborhood }

end
