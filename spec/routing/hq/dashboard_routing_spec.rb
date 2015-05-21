require 'rails_helper'

RSpec.describe 'Hq::Dashboard routing', type: :routing do
  specify { expect(get: '/hq/dashboard'). to be_routable } #new
end