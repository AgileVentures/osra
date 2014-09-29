require 'rails_helper'

describe 'Sponsorships routing', type: :routing do
  specify { expect(post: '/admin/sponsors/1/sponsorships?orphan_id=1').to be_routable }
  specify { expect(put: '/admin/sponsors/1/sponsorships/make_inactive?orphan_id=1').to be_routable }
end
