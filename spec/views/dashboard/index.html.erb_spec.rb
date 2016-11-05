require 'rails_helper'

RSpec.describe "dashboard/index.html.erb", type: :view do
  describe 'Dashboard display' do
    it "should have an osra image at the center" do
      render

      expect(rendered).to have_selector("img[src*='osra_logo']")
    end
  end
end
