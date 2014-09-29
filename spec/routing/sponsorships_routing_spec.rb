require 'rails_helper'

describe 'Sponsorships routing', type: :routing do
  specify { expect(post: '/admin/sponsors/1/sponsorships').to be_routable }
  specify { expect(put: '/admin/sponsors/1/sponsorships/make_inactive').to be_routable }
end
