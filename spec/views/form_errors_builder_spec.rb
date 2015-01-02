require 'rails_helper'
require 'cgi'

RSpec.describe "hq/partners/_form.html.erb", type: :view do

  let(:provinces) { Province.all }
  let(:statuses) { Status.all }
  let(:partner) { build :partner, name: nil, region: "Test Region"}

  before :each do
    assign(:provinces, provinces)
    assign(:statuses, statuses)
    assign(:partner, partner)
    partner.valid?
    render
  end

  it 'tells us we have errors' do
    assert_select ".panel-title", /Please fix the errors below and resubmit the form/
  end

  it "tells us name can't be blank" do
    assert_select ".panel-body", /#{CGI::escape_html("Name can't be blank")}/
  end

end

