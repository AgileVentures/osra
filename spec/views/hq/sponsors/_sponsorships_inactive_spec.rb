require 'rails_helper'

RSpec.describe 'hq/sponsors/_sponsorships_inactive.html.haml', type: :view do
  let(:orphan) {build_stubbed :orphan}
  let(:sponsorships_inactive) {(1..2).map {build_stubbed :sponsorship, active: false, orphan: orphan}}

  describe "inactive sponsorships exist" do
    before :each do
      render :partial => 'hq/sponsors/sponsorships_inactive.html.haml', :locals => {sponsorships: sponsorships_inactive}
    end

    it "should show table title" do
      expect(rendered).to have_text "2 previously sponsored orphans"
    end

    it "should show sponsorships and linked orphans details" do
      sponsorships_inactive.each do |sa|
        expect(rendered).to have_link(sa.orphan.name, hq_orphan_path(sa.orphan_id))
        expect(rendered).to have_text(sa.orphan.date_of_birth)
        expect(rendered).to have_text(sa.orphan.gender)
        expect(rendered).to have_text(sa.start_date)
        expect(rendered).to have_text(sa.end_date)
      end
    end
  end

  describe "active sponsorships exist" do
    before :each do
      render :partial => 'hq/sponsors/sponsorships_inactive.html.haml', :locals => {sponsorships: []}
    end

    it "should show message" do
      expect(rendered).to have_text "No previously sponsored orphans"
    end
  end

end
