require 'rails_helper'

RSpec.describe 'Orphans routing', type: :routing do
  describe 'CRUD' do
    specify '#index' do
      expect(get: '/orphans').       to be_routable
    end
    specify '#create' do
      expect(post: '/orphans').      not_to be_routable
    end
    specify '#new' do
      expect(get: '/orphans/new').   not_to route_to('/orphans#new')
    end
    specify '#show' do
      expect(get: '/orphans/1').     to be_routable
    end
    specify '#edit' do
      expect(get: '/orphans/1/edit').to be_routable
    end
    specify '#update' do
      expect(put: '/orphans/1').     to be_routable
      expect(patch: '/orphans/1').   to be_routable
    end
    specify '#destroy' do
      expect(delete: '/orphans/1').  not_to be_routable
    end
  end
end
