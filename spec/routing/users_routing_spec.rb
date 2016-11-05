require 'rails_helper'

RSpec.describe 'Hq::Users routing', type: :routing do
  specify { expect(get: '/hq/users').          to be_routable } #index
  specify { expect(post: '/hq/users').         to be_routable } #create
  specify { expect(get: '/hq/users/new').      to be_routable } #new
  specify { expect(get: '/hq/users/1').        to be_routable } #show
  specify { expect(get: '/hq/users/1/edit').   to be_routable } #edit
  specify { expect(put: '/hq/users/1').        to be_routable } #update
  specify { expect(patch: '/hq/users/1').      to be_routable } #update
  specify { expect(delete: '/hq/users/1'). not_to be_routable } #destroy
end
