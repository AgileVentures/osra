require 'rails_helper'

RSpec.describe 'Hq::Orphan Lists routing', type: :routing do
  specify { pending('uninitialized constant Hq::OrphanListsController')
            expect(get: '/hq/partners/1/orphan_lists').           to be_routable } #index
  specify { expect(post: '/hq/partners/1/orphan_lists').      not_to be_routable } #create
  specify { expect(get: '/hq/partners/1/orphan_lists/new').   not_to be_routable } #new
  specify { expect(get: '/hq/partners/1/orphan_lists/1').     not_to be_routable } #show
  specify { expect(get: '/hq/partners/1/orphan_lists/1/edit').not_to be_routable } #edit
  specify { expect(put: '/hq/partners/1/orphan_lists/1').     not_to be_routable } #update
  specify { expect(patch: '/hq/partners/1/orphan_lists/1').   not_to be_routable } #update
  specify { expect(delete: '/hq/partners/1/orphan_lists/1').  not_to be_routable } #destroy
end
