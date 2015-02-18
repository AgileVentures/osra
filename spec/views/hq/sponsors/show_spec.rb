require 'rails_helper'

RSpec.describe "hq/sponsors/show.html.haml", type: :view do
  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:sponsor) { FactoryGirl.build_stubbed(:sponsor, agent: user) }

  describe 'the sponsor exists' do
    before :each do
      assign(:sponsor, sponsor)
      render
    end

    it 'should show the assigned sponsor details' do
      expect(rendered).to match sponsor.name
    end

    it 'should have an Edit Sponsor button' do
      expect(rendered).to have_link('Edit Sponsor', edit_hq_sponsor_path(sponsor.id))
    end

    it 'should have a Link to Orphan button' do
      expect(rendered).to have_link('Link to Orphan')
    end
  end

end
