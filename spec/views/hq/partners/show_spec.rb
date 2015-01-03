require 'rails_helper'

RSpec.describe "hq/partners/show.html.erb", type: :view do
  let(:partner) do
    FactoryGirl.build_stubbed :partner, created_at: Date.current, updated_at: Date.current
  end

  describe 'orphan lists link' do
    before :each do
      assign :partner, partner
    end

    it 'disappears when lists absent' do
      render
      expect(rendered).to match /none/
      expect(rendered).to_not have_link('All orphan lists',
              href: hq_partner_orphan_lists_path(partner.id))
    end

    it 'appears when lists present' do
      allow(partner).to receive_message_chain(:orphan_lists, :empty?).and_return false
      render
      expect(rendered).to have_link('All orphan lists',
              href: hq_partner_orphan_lists_path(partner.id))
    end
  end
end
