require 'rails_helper'

describe 'Sponsorships routing', type: :routing do
  specify { expect(post: '/sponsors/1/sponsorships?orphan_id=1').to be_routable }
  specify { expect(put: '/sponsors/1/sponsorships/1/inactivate').not_to be_routable }
  specify { expect(get: '/sponsors/1/sponsorships/new').to be_routable }
  specify { expect(get: '/sponsors/1/sponsorships').not_to be_routable }
  specify { expect(get: '/sponsors/1/sponsorships/1').not_to be_routable }
  specify { expect(get: '/sponsors/1/sponsorships/1/edit').not_to be_routable }
  specify { expect(patch: '/sponsors/1/sponsorships/1').not_to be_routable }
  specify { expect(put: '/sponsors/1/sponsorships/1').not_to be_routable }
  specify { expect(delete: '/sponsors/1/sponsorships/1').not_to be_routable }
end
