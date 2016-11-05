require 'rails_helper'

RSpec.describe 'Hq::PendingOrphanLists routing', type: :routing do
  describe 'CRUD' do
    specify '#index' do
      expect(get: '/hq/partners/1/pending_orphan_lists').       not_to be_routable
    end
    specify '#create' do
      expect(post: '/hq/partners/1/pending_orphan_lists').      not_to be_routable
    end
    specify '#new' do
      expect(get: '/hq/partners/1/pending_orphan_lists/new').   not_to be_routable
    end
    specify '#show' do
      expect(get: '/hq/partners/1/pending_orphan_lists/1').     not_to be_routable
    end
    specify '#edit' do
      expect(get: '/hq/partners/1/pending_orphan_lists/1/edit').not_to be_routable
    end
    specify '#update' do
      expect(put: '/hq/partners/1/pending_orphan_lists/1').     not_to be_routable
      expect(patch: '/hq/partners/1/pending_orphan_lists/1').   not_to be_routable
    end
    specify '#destroy' do
      pending('method-missing Hq::PendingOrphanListsController#destroy')
      expect(delete: '/hq/partners/1/pending_orphan_lists/1').      to be_routable
    end
  end
  describe 'non-CRUD' do
    specify '#upload' do
      expect(get: '/hq/partners/1/pending_orphan_lists/upload').    to be_routable
    end
    specify '#validate' do
      expect(post: '/hq/partners/1/pending_orphan_lists/validate'). to be_routable
    end
    specify '#import' do
      expect(post: '/hq/partners/1/pending_orphan_lists/import').   to be_routable
    end
  end
end
