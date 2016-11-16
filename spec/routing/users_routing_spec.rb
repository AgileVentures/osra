require 'rails_helper'

RSpec.describe 'Users routing', type: :routing do
  specify { expect(get: '/users').          to be_routable } #index
  specify { expect(post: '/users').         to be_routable } #create
  specify { expect(get: '/users/new').      to be_routable } #new
  specify { expect(get: '/users/1').        to be_routable } #show
  specify { expect(get: '/users/1/edit').   to be_routable } #edit
  specify { expect(put: '/users/1').        to be_routable } #update
  specify { expect(patch: '/users/1').      to be_routable } #update
  specify { expect(delete: '/users/1'). not_to be_routable } #destroy
end
