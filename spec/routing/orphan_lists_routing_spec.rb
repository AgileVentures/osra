require 'rails_helper'

RSpec.describe 'Orphan Lists routing', type: :routing do
  specify { expect(get: '/partners/1/orphan_lists').           to be_routable } #index
  specify { expect(post: '/partners/1/orphan_lists').      not_to be_routable } #create
  specify { expect(get: '/partners/1/orphan_lists/new').   not_to be_routable } #new
  specify { expect(get: '/partners/1/orphan_lists/1').     not_to be_routable } #show
  specify { expect(get: '/partners/1/orphan_lists/1/edit').not_to be_routable } #edit
  specify { expect(put: '/partners/1/orphan_lists/1').     not_to be_routable } #update
  specify { expect(patch: '/partners/1/orphan_lists/1').   not_to be_routable } #update
  specify { expect(delete: '/partners/1/orphan_lists/1').  not_to be_routable } #destroy
end
