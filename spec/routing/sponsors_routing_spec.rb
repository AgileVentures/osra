require 'rails_helper'

RSpec.describe 'Sponsors routing', type: :routing do
  describe 'CRUD' do
    specify '#index' do
      expect(get: '/sponsors').          to be_routable
    end
    specify '#create' do
      expect(post: '/sponsors').         to be_routable
    end
    specify '#new' do
      expect(get: '/sponsors/new').      to be_routable
    end
    specify '#show' do
      expect(get: '/sponsors/1').        to be_routable
    end
    specify '#edit' do
      expect(get: '/sponsors/1/edit').   to be_routable
    end
    specify '#update' do
      expect(put: '/sponsors/1').        to be_routable
      expect(patch: '/sponsors/1').      to be_routable
    end
    specify '#destroy' do
      expect(delete: '/sponsors/1'). not_to be_routable
    end
  end
end
