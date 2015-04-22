require 'rails_helper'

RSpec.describe 'Hq::AdminUser Sessions routing', type: :routing do
  specify { expect(get: '/login'). to be_routable } #new
  specify { expect(post: '/login').to be_routable } #create
  specify { expect(get: '/logout').to be_routable } #destroy
end
