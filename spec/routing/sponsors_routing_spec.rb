require 'rails_helper'

describe 'Sponsors routing', type: :routing do
  specify { expect(get: '/admin/sponsors').to be_routable }
  specify { expect(post: '/admin/sponsors').to be_routable }
  specify { expect(get: '/admin/sponsors/new').to be_routable }
  specify { expect(get: '/admin/sponsors/1').to be_routable }
  specify { expect(get: '/admin/sponsors/1/edit').to be_routable }
  specify { expect(put: '/admin/sponsors/1').to be_routable }
  specify { expect(patch: '/admin/sponsors/1').to be_routable }
  specify { expect(delete: '/admin/sponsors/1').not_to be_routable }
end
