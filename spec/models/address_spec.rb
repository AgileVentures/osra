require 'rails_helper'

RSpec.describe Address, :type => :model do

  it {should validate_presence_of(:province)}

  it {should validate_presence_of(:city)}

  it {should validate_presence_of(:neighborhood)}

end
