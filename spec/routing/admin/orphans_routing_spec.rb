require 'rails_helper'

describe 'Orphans routing', type: :routing do
  specify { expect(get: '/admin/orphans').to be_routable }
  specify { expect(post: '/admin/orphans').not_to be_routable }
  specify { expect(get: '/admin/orphans/1').to be_routable }
  specify { expect(get: '/admin/orphans/1/edit').to be_routable }
  specify { expect(put: '/admin/orphans/1').to be_routable }
  specify { expect(patch: '/admin/orphans/1').to be_routable }
  specify { expect(delete: '/admin/orphans/1').not_to be_routable }
end
