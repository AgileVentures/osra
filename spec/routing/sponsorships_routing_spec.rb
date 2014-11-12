require 'rails_helper'

describe 'Sponsorships routing', type: :routing do
  specify { expect(post: '/admin/sponsors/1/sponsorships?orphan_id=1').to be_routable }
  specify { expect(put: '/admin/sponsors/1/sponsorships/1/inactivate').to be_routable }
  specify { expect(get: '/admin/sponsors/1/sponsorships/new').not_to be_routable }
  specify { expect(get: '/admin/sponsors/1/sponsorships').not_to be_routable }
  specify { expect(get: '/admin/sponsors/1/sponsorships/1').not_to be_routable }
  specify { expect(get: '/admin/sponsors/1/sponsorships/1/edit').not_to be_routable }
  specify { expect(patch: '/admin/sponsors/1/sponsorships/1').not_to be_routable }
  specify { expect(put: '/admin/sponsors/1/sponsorships/1').not_to be_routable }
  specify { expect(delete: '/admin/sponsors/1/sponsorships/1').not_to be_routable }
end
