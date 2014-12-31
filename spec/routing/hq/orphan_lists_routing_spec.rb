require 'rails_helper'

RSpec.describe 'Hq::Orphan Lists routing', type: :routing do
  specify { pending('uninitialized constant Hq::OrphanListsController')
            expect(get: '/hq/partners/1/orphan_lists').           to be_routable }
  specify { expect(get: '/hq/partners/1/orphan_lists/new').   not_to be_routable }
  specify { expect(get: '/hq/partners/1/orphan_lists/1').     not_to be_routable }
  specify { expect(get: '/hq/partners/1/orphan_lists/1/edit').not_to be_routable }
  specify { expect(put: '/hq/partners/1/orphan_lists/1').     not_to be_routable }
  specify { expect(patch: '/hq/partners/1/orphan_lists/1').   not_to be_routable }
  specify { expect(delete: '/hq/partners/1/orphan_lists/1').  not_to be_routable }
end
