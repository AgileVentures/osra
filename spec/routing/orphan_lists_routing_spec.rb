require 'rails_helper'

describe 'Orphan Lists routing', type: :routing do
  specify { expect(get: '/admin/partners/1/orphan_lists/upload').to be_routable }
  specify { expect(post: '/admin/partners/1/orphan_lists/validate').to be_routable }
  specify { expect(post: '/admin/partners/1/orphan_lists/import').to be_routable }
  specify { expect(get: '/admin/partners/1/orphan_lists/new').not_to be_routable }
  specify { expect(get: '/admin/partners/1/orphan_lists/1').not_to be_routable }
  specify { expect(get: '/admin/partners/1/orphan_lists/1/edit').not_to be_routable }
  specify { expect(put: '/admin/partners/1/orphan_lists/1').not_to be_routable }
  specify { expect(patch: '/admin/partners/1/orphan_lists/1').not_to be_routable }
  specify { expect(delete: '/admin/partners/1/orphan_lists/1').not_to be_routable }
end
