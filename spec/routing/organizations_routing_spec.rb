require 'rails_helper'

describe 'Organizations routing', type: :routing do
  specify { expect(get: '/admin/organizations').to be_routable }
  specify { expect(post: '/admin/organizations').to be_routable }
  specify { expect(get: '/admin/organizations/new').to be_routable }
  specify { expect(get: '/admin/organizations/1').to be_routable }
  specify { expect(get: '/admin/organizations/1/edit').to be_routable }
  specify { expect(put: '/admin/organizations/1').to be_routable }
  specify { expect(patch: '/admin/organizations/1').to be_routable }
  specify { expect(delete: '/admin/organizations/1').not_to be_routable }
end
