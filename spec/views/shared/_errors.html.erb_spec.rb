require 'rails_helper'
require 'cgi'

RSpec.describe "shared/_errors.html.erb", type: :view do

  before :each do
    partner = build_stubbed :partner, name: nil, region: "Test Region"
    partner.valid?
    render 'shared/errors', object: partner
  end

  it 'tells us we have errors' do
    assert_select ".panel-title", /Please fix the errors below and resubmit the form/
  end

  it "tells us name can't be blank" do
    assert_select ".panel-body", /#{CGI::escape_html("Name can't be blank")}/
  end

end

