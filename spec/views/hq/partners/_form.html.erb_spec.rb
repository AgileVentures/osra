require 'rails_helper'
require 'cgi'

RSpec.describe "hq/partners/_form.html.erb", type: :view do

  let(:provinces) { Province.all }
  let(:statuses) { Status.all }
  let(:partner) { build_stubbed :partner }

  before :each do
    assign(:provinces, provinces)
    assign(:statuses, statuses)
    assign(:partner, partner)
  end

  specify 'has a form' do
    render

    assert_select "form"
  end

  context 'render value' do
    specify 'Name' do
      render

      assert_select "input#partner_name", value: partner.name
    end

    specify 'Region' do
      render

      assert_select "input#partner_region", value: partner.region
    end

    specify 'Contact Details' do
      render

      assert_select "input#partner_name", value: partner.contact_details
    end

    specify 'Province' do
      render

      assert_select "select#partner_province_id" do
        assert_select "option", value: provinces.first.id,
                                 html: CGI::escape_html(provinces.first.name)
      end
    end

    specify 'Status' do
      render

      assert_select "select#partner_status_id" do
        assert_select "option", value: statuses.first.id,
                                 html: statuses.first.name
      end
    end

    specify 'Start Date' do
      render

      assert_select "input#partner_start_date", value: partner.start_date
    end

    specify 'Submit' do
      render

      assert_select "input", type: "submit"
    end
  end

end

