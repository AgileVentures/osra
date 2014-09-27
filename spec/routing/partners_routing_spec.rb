require 'rails_helper'

describe 'Partners routing', type: :routing do
  specify { expect(get: '/admin/partners').to be_routable }
  specify { expect(post: '/admin/partners').to be_routable }
  specify { expect(get: '/admin/partners/new').to be_routable }
  specify { expect(get: '/admin/partners/1').to be_routable }
  specify { expect(get: '/admin/partners/1/edit').to be_routable }
  specify { expect(put: '/admin/partners/1').to be_routable }
  specify { expect(patch: '/admin/partners/1').to be_routable }
  specify { expect(delete: '/admin/partners/1').not_to be_routable }
end
