require 'rails_helper'

RSpec.describe "partners/show.html.erb", type: :view do
  let(:partner) do
    FactoryGirl.build_stubbed :partner
  end

  before :each do
    assign :partner, partner
  end

  describe 'instance action-items' do
    specify 'Edit Partner' do
      render
      expect(rendered).to have_link('Edit Partner', edit_partner_path(partner.id))
    end

    specify 'Upload Orphan List button' do
      render
      expect(rendered).to have_link('Upload Orphan List', upload_partner_pending_orphan_lists_path(partner.id))
    end

    describe 'Orphan Lists button' do
      it 'is disabled when lists absent' do
        render
        expect(rendered).to have_selector("a[href='#{partner_orphan_lists_path(partner.id)}'][disabled]",
          :text => "Orphan lists")
      end

      it 'is enabled when lists present' do
        allow(partner).to receive_message_chain(:orphan_lists, :empty?).and_return false
        render
        expect(rendered).to have_selector("a[href='#{partner_orphan_lists_path(partner.id)}']",
          :text => "Orphan lists")

        expect(rendered).not_to have_selector("a[disabled]", :text => "Orphan lists")

      end
    end
  end
end
