require 'rails_helper'

RSpec.describe 'Hq::Orphans routing', type: :routing do
  describe 'CRUD' do
    specify '#index' do
      expect(get: '/hq/orphans').       to be_routable
    end
    specify '#create' do
      expect(post: '/hq/orphans').      not_to be_routable
    end
    specify '#new' do
      expect(get: '/hq/orphans/new').   not_to route_to('/hq/orphans#new')
    end
    specify '#show' do
      expect(get: '/hq/orphans/1').     to be_routable
    end
    specify '#edit' do
      expect(get: '/hq/orphans/1/edit').to be_routable
    end
    specify '#update' do
      expect(put: '/hq/orphans/1').     to be_routable
      expect(patch: '/hq/orphans/1').   to be_routable
    end
    specify '#destroy' do
      expect(delete: '/hq/orphans/1').  not_to be_routable
    end
  end
end
