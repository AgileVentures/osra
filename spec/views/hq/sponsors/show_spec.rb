require 'rails_helper'

RSpec.describe "hq/sponsors/show.html.haml", type: :view do
  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:sponsor) { FactoryGirl.build_stubbed(:sponsor, agent: user) }

  describe 'the sponsor exists' do
    before :each do
      assign(:sponsor, sponsor)
    end

    it 'should show the assigned sponsor details' do
      render and expect(rendered).to match sponsor.name
    end

    it 'should have an Edit Sponsor button' do
      render

      expect(rendered).to have_link('Edit Sponsor', edit_hq_sponsor_path(sponsor.id))
    end
  end

end
