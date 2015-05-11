require 'rails_helper'

describe 'Sponsorships routing', type: :routing do
  specify { expect(post: '/hq/sponsors/1/sponsorships?orphan_id=1').to be_routable }
  specify { expect(get: '/admin/sponsors/1/sponsorships/new').to be_routable }
  specify { expect(get: '/admin/sponsors/1/sponsorships').not_to be_routable }
  specify { expect(get: '/admin/sponsors/1/sponsorships/1').not_to be_routable }
end
