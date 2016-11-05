require 'rails_helper'

RSpec.describe 'sponsors/_sponsorships_inactive.html.haml', type: :view do
  let(:sponsorships_inactive) {build_stubbed_list :sponsorship, 2, active: false, orphan: build_stubbed(:orphan)}

  describe "inactive sponsorships exist" do
    before :each do
      render :partial => 'sponsors/sponsorships_inactive.html.haml', :locals => {sponsorships: sponsorships_inactive}
    end

    it "should show table title" do
      expect(rendered).to have_text "2 Previously Sponsored Orphans"
    end

    it "should show sponsorships and linked orphans details" do
      sponsorships_inactive.each do |sa|
        expect(rendered).to have_link(sa.orphan.name, orphan_path(sa.orphan))
        expect(rendered).to have_text(sa.orphan.date_of_birth)
        expect(rendered).to have_text(sa.orphan.gender)
        expect(rendered).to have_text(sa.start_date)
        expect(rendered).to have_text(sa.end_date)
      end
    end
  end

  describe "inactive sponsorships do not exist" do
    before :each do
      render :partial => 'sponsors/sponsorships_inactive.html.haml', :locals => {sponsorships: []}
    end

    it "should show message" do
      expect(rendered).to have_text "0 Previously Sponsored Orphans"
    end
  end

end
