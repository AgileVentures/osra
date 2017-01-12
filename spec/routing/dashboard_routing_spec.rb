require 'rails_helper'

RSpec.describe 'Dashboard routing', type: :routing do
  specify { expect(get: '/dashboard'). to be_routable } #index
end
