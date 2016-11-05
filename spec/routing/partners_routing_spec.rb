require 'rails_helper'

RSpec.describe 'Hq::Partners routing', type: :routing do
  specify { expect(get: '/hq/partners').          to be_routable } #index
  specify { expect(post: '/hq/partners').         to be_routable } #create
  specify { expect(get: '/hq/partners/new').      to be_routable } #new
  specify { expect(get: '/hq/partners/1').        to be_routable } #show
  specify { expect(get: '/hq/partners/1/edit').   to be_routable } #edit
  specify { expect(put: '/hq/partners/1').        to be_routable } #update
  specify { expect(patch: '/hq/partners/1').      to be_routable } #update
  specify { expect(delete: '/hq/partners/1'). not_to be_routable } #destroy
end


