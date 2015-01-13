require 'rails_helper'
require 'cgi'

RSpec.describe 'hq/partners/_form.html.erb', type: :view do
  let(:provinces) { Province.all }
  let(:statuses) { Status.all }
  let(:partner) { build_stubbed :partner,
                  region: 'Region1', contact_details: 'CD123'}

  before :each do
    assign(:provinces, provinces)
    assign(:statuses, statuses)
    assign(:partner, partner)
  end

  specify 'has a form' do
    render and assert_select 'form'
  end

  describe '"Cancel" button' do
    specify 'when no :id' do
      allow(partner).to receive(:id).and_return nil
      render
      assert_select 'a[href=?]', hq_partners_path, role: 'button', text: 'Cancel'
    end

    specify 'when :id' do
      allow(partner).to receive(:id).and_return 42
      render
      assert_select 'a[href=?]', hq_partner_path(42), role: 'button', text: 'Cancel'
    end
  end

  specify 'form values' do
    render

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

