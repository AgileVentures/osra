require 'rails_helper'
require 'cgi'

RSpec.describe "shared/_errors.html.erb", type: :view do

  before :each do
    partner = build_stubbed :partner, name: nil, region: "Test Region"
    partner.valid?
    render 'shared/errors', object: partner
  end

  it 'tells us we have errors' do
    expect(rendered).to have_selector(".panel-title", text: /Please fix the errors below and resubmit the form/)
  end

  it "tells us name can't be blank" do
    expect(rendered).to have_selector(".panel-body" ,text: /Name can't be blank/)
  end

end

