require 'rails_helper'

RSpec.describe 'Hq::AdminUser Sessions routing', type: :routing do
  specify { expect(get: '/hq/login'). to be_routable } #new
  specify { expect(post: '/hq/login').to be_routable } #create
  specify { expect(delete: '/hq/logout').to be_routable } #destroy
end
