require 'rails_helper'

RSpec.describe 'hq/sponsors/_sponsorships_active.html.haml', type: :view do
  let(:orphan) {build_stubbed :orphan}
  let(:sponsorships_active) {(1..3).map {build_stubbed :sponsorship, active: true, orphan: orphan}}

  describe "active sponsorships exist" do
    before :each do
      render :partial => 'hq/sponsors/sponsorships_active.html.haml', :locals => {sponsorships: sponsorships_active}
    end

    it "should show table title" do
      expect(rendered).to have_text "3 currently sponsored orphans"
    end

    it "should show sponsorships and linked orphans details" do
      sponsorships_active.each do |sa|
        expect(rendered).to have_link(sa.orphan.name, hq_orphan_path(sa.orphan_id))
        expect(rendered).to have_text(sa.orphan.date_of_birth)
        expect(rendered).to have_text(sa.orphan.gender)
        expect(rendered).to have_text(sa.start_date)
      end
    end

    it "should have End Sponsorship form" do
      expect(rendered).to have_button "End Sponsorship"
      expect(rendered).to have_css("input[type='text'][value='#{Date.current}']")
    end

    it "should have Delete button" do
      sponsorships_active.each do |sa|
        expect(rendered).to have_link "Delete", hq_sponsor_sponsorship_path(sa.sponsor_id,sa)
      end
    end
  end

  describe "active sponsorships does not exist" do
    before :each do
      render :partial => 'hq/sponsors/sponsorships_active.html.haml', :locals => {sponsorships: []}
    end

    it "should show message" do
      expect(rendered).to have_text "No currently sponsored orphans"
    end
  end

end