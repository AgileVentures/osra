require 'rails_helper'

RSpec.describe "sponsors/show.html.haml", type: :view do
  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:sponsor) { FactoryGirl.build_stubbed(:sponsor, agent: user) }

  describe 'the sponsor exists' do
    before :each do
      assign(:sponsor, sponsor)
      assign(:sponsorships_active, Sponsorship.none)
      assign(:sponsorships_inactive, Sponsorship.none)
      render
    end

    it 'should show the assigned sponsor details' do
      expect(rendered).to match sponsor.name
    end

    it 'should have an Edit Sponsor button' do
      expect(rendered).to have_link('Edit Sponsor', edit_sponsor_path(sponsor.id))
    end

    it 'should have a Link to Orphan button' do
      expect(rendered).to have_link('Link to Orphan')
    end

    it 'should delegate to partials' do
      expect(view).to render_template partial: 'sponsors/sponsorships_active.html.haml', locals: {sponsorships: []}
      expect(view).to render_template partial: 'sponsors/sponsorships_inactive.html.haml', locals: {sponsorships: []}
    end
  end

end
