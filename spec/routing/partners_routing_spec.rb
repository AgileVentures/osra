require 'rails_helper'

RSpec.describe 'Partners routing', type: :routing do
  specify { expect(get: '/partners').          to be_routable } #index
  specify { expect(post: '/partners').         to be_routable } #create
  specify { expect(get: '/partners/new').      to be_routable } #new
  specify { expect(get: '/partners/1').        to be_routable } #show
  specify { expect(get: '/partners/1/edit').   to be_routable } #edit
  specify { expect(put: '/partners/1').        to be_routable } #update
  specify { expect(patch: '/partners/1').      to be_routable } #update
  specify { expect(delete: '/partners/1'). not_to be_routable } #destroy
end


