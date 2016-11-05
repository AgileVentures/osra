require 'rails_helper'

RSpec.describe 'sponsors/_sponsorships_active.html.haml', type: :view do
  let(:sponsorships_active) {build_stubbed_list :sponsorship, 3, active:true, orphan: build_stubbed(:orphan)}

  describe "active sponsorships exist" do
    before :each do
      render :partial => 'sponsors/sponsorships_active.html.haml', :locals => {sponsorships: sponsorships_active}
    end

    it "should show table title" do
      expect(rendered).to have_text "3 Currently Sponsored Orphans"
    end

    it "should show sponsorships and linked orphans details" do
      sponsorships_active.each do |sa|
        expect(rendered).to have_link(sa.orphan.name, orphan_path(sa.orphan))
        expect(rendered).to have_text(sa.orphan.date_of_birth)
        expect(rendered).to have_text(sa.orphan.gender)
        expect(rendered).to have_text(sa.start_date)
      end
    end

    it "should have End Sponsorship form" do
      expect(rendered).to have_button "End Sponsorship", inactivate_sponsorship_path(sponsorships_active.first)
      expect(rendered).to have_css("input[type='text'][value='#{Date.current}']")
    end

    it "should have delete (X) button" do
      sponsorships_active.each do |sa|
        expect(rendered).to have_link "X", sponsorship_path(sa)
      end
    end
  end

  describe "active sponsorships do not exist" do
    before :each do
      render :partial => 'sponsors/sponsorships_active.html.haml', :locals => {sponsorships: []}
    end

    it "should show message" do
      expect(rendered).to have_text "0 Currently Sponsored Orphans"
    end
  end

end
