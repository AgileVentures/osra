require 'rails_helper'
require 'cgi'

RSpec.describe "hq/partners/_form.html.erb", type: :view do

  let(:provinces) { Province.all }
  let(:statuses) { Status.all }
  let(:partner) { build_stubbed :partner,
                  region: "Region1", contact_details: "CD123"}

  before :each do
    assign(:provinces, provinces)
    assign(:statuses, statuses)
    assign(:partner, partner)
    render
  end

  specify 'has a form' do
    assert_select "form"
  end

  specify 'renders each form value' do
    assert_select "input#partner_name" do
      assert_select "[value=?]", CGI::escape_html(partner.name)
    end

    assert_select "input#partner_region" do
      assert_select "[value=?]",  CGI::escape_html(partner.region)
    end

    assert_select "input#partner_contact_details" do
      assert_select "[value=?]",  CGI::escape_html(partner.contact_details)
    end

    assert_select "select#partner_province_id" do
      assert_select "option", value: provinces.first.id,
                               html: CGI::escape_html(provinces.first.name)
    end

    assert_select "select#partner_status_id" do
      assert_select "option", value: statuses.first.id,
                               html: CGI::escape_html(statuses.first.name)
    end

    assert_select "input#partner_start_date" do
      assert_select "[value=?]", partner.start_date
    end

    assert_select "input", type: "submit"
  end

end

