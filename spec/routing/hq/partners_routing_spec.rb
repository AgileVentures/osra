require 'rails_helper'

RSpec.describe 'Hq::Partners routing', type: :routing do
  specify { expect(get: '/hq/partners').          to be_routable }
  specify { expect(post: '/hq/partners').         to be_routable }
  specify { expect(get: '/hq/partners/new').      to be_routable }
  specify { expect(get: '/hq/partners/1').        to be_routable }
  specify { expect(get: '/hq/partners/1/edit').   to be_routable }
  specify { expect(put: '/hq/partners/1').        to be_routable }
  specify { expect(patch: '/hq/partners/1').      to be_routable }
  specify { expect(delete: '/hq/partners/1'). not_to be_routable }
end
