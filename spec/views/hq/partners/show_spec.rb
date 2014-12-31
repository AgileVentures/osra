require 'rails_helper'

RSpec.describe "hq/partners/show.html.erb", type: :view do
  let(:partner) do
    FactoryGirl.create(:partner)
  end

  context 'orphan lists link' do
    before :each do
      assign :partner, partner
    end

    it 'disappears when lists absent' do
      render
      expect(rendered).to match /none/
      expect(rendered).to_not match /#{hq_partner_orphan_lists_path(partner.id)}/
    end

    it 'appears when lists present' do
      FactoryGirl.create(:orphan_list, partner_id: partner.id)
      render
      expect(rendered).to_not match /none/
      expect(rendered).to match /#{hq_partner_orphan_lists_path(partner.id)}/
    end
  end
end
