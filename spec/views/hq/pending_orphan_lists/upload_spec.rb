require 'rails_helper'

RSpec.describe "hq/pending_orphan_lists/upload.html.erb", type: :view do
  let(:partner) { FactoryGirl.build_stubbed :partner }

  before :each do
    assign :partner, partner
  end

  it 'shows Spredsheet upload form' do
    render

    expect(rendered).to have_selector("input[type='file']")
    expect(rendered).to have_selector("input[type='submit'][value='Upload']")
    expect(rendered).to have_link("Cancel")
  end

end
