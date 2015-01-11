require 'rails_helper'

RSpec.describe 'Hq::Sponsors routing', type: :routing do
  describe 'CRUD' do
    specify '#index' do
      expect(get: '/hq/sponsors').          to be_routable
    end
    specify '#create' do
      expect(post: '/hq/sponsors').         to be_routable
    end
    specify '#new' do
      expect(get: '/hq/sponsors/new').      to be_routable
    end
    specify '#show' do
      expect(get: '/hq/sponsors/1').        to be_routable
    end
    specify '#edit' do
      expect(get: '/hq/sponsors/1/edit').   to be_routable
    end
    specify '#update' do
      expect(put: '/hq/sponsors/1').        to be_routable
      expect(patch: '/hq/sponsors/1').      to be_routable
    end
    specify '#destroy' do
      expect(delete: '/hq/sponsors/1'). not_to be_routable
    end
  end
end
