require 'rails_helper'

RSpec.describe "hq/partners/show.html.erb", type: :view do
  let(:partner) do
    FactoryGirl.build_stubbed :partner
  end

  before :each do
    assign :partner, partner
  end

  describe 'instance action-items' do
    specify 'Edit Partner' do
      render
      expect(rendered).to have_link('Edit Partner', edit_hq_partner_path(partner.id))
    end

    specify 'Upload Orphan List' do
      render
      expect(rendered).to have_link('Upload Orphan List', upload_hq_partner_pending_orphan_lists_path(partner.id))
    end

    describe 'Orphan Lists' do
      it 'disappears when lists absent' do
        render
        expect(rendered).to_not have_link('Orphan lists',
                href: hq_partner_orphan_lists_path(partner.id))
      end

      it 'appears when lists present' do
        allow(partner).to receive_message_chain(:orphan_lists, :empty?).and_return false
        render
        expect(rendered).to have_link('Orphan lists',
                href: hq_partner_orphan_lists_path(partner.id))
      end
    end
  end
end
