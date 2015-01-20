require 'rails_helper'
require 'cgi'

RSpec.describe "hq/sponsors/_form.html.haml", type: :view do
  let(:user) { build_stubbed :user}
  let(:sponsor) { build_stubbed :sponsor, agent: user, request_fulfilled: [true, false].sample }
  let(:new_sponsor) { Sponsor.new }

  before :each do
    assign :sponsor, sponsor
    assign :statuses, Status.all
    assign :sponsor_types, SponsorType.all
    assign :organizations, Organization.all
    assign :branches, Branch.all
    assign :cities, [sponsor.city].unshift(Sponsor::NEW_CITY_MENU_OPTION)
  end

  specify 'has a form' do
    render

    assert_select 'form'
  end

  describe 'has a "Cancel" button' do
    specify 'using an existing Sponsor record' do
      allow(sponsor).to receive(:id).and_return sponsor.id
      render

      assert_select 'a[href=?]', hq_sponsors_path, text: 'Cancel'   # hq_partner_path(sponsor.id)  after #show is merged
    end

    specify 'using a new Sponsor record' do
      allow(sponsor).to receive(:id).and_return nil
      render

      assert_select 'a[href=?]', hq_sponsors_path, text: 'Cancel'
    end
  end

  describe 'has form values' do
    specify 'using an existing Sponsor record' do
      allow(User).to receive(:pluck).and_return([user.user_name, user.id])
      render

      assert_select "input#sponsor_name" do
        assert_select "[value=?]", CGI::escape_html(sponsor.name)
      end

      assert_select "select#sponsor_status_id" do
        assert_select "option", value: sponsor.status_id,
                                html: CGI::escape_html(sponsor.status.name)
      end

      assert_select "select#sponsor_gender" do
        assert_select "option", value: Settings.lookup.gender.first,
                                html: CGI::escape_html(Settings.lookup.gender.first)
      end

      assert_select "input#sponsor_start_date" do
        assert_select "[value=?]", sponsor.start_date
      end

      assert_select "input#sponsor_requested_orphan_count" do
        assert_select "[value=?]", sponsor.requested_orphan_count
      end

      assert_select "input#sponsor_request_fulfilled" do
        assert_select "[disabled=?]", "disabled"
        assert_select "[value=?]", sponsor.request_fulfilled ? "1" : "0"
        assert_select "[checked]", true if sponsor.request_fulfilled
      end

      assert_select "select#sponsor_sponsor_type_id" do
        assert_select "[disabled=?]", "disabled"
        assert_select "option", value: sponsor.sponsor_type_id,
                                html: CGI::escape_html(sponsor.sponsor_type.name)
      end

      assert_select "select#sponsor_organization_id" do
        assert_select "[disabled=?]", "disabled"
        assert_select "option", value: sponsor.organization_id
        assert_select "option", html: CGI::escape_html(sponsor.organization.name) if sponsor.organization
      end

      assert_select "select#sponsor_branch_id" do
        assert_select "[disabled=?]", "disabled"
        assert_select "option", value: sponsor.branch_id
        assert_select "option", html: CGI::escape_html(sponsor.branch.name) if sponsor.branch
      end

      assert_select "select#sponsor_payment_plan" do
        assert_select "option", value: sponsor.payment_plan,   
                                html: CGI::escape_html(sponsor.payment_plan)
      end

      assert_select "select#sponsor_country" do
        assert_select "option", value: sponsor.country,
                                html: CGI::escape_html(en_ar_country sponsor.country)
      end

      assert_select "select#sponsor_city" do
        assert_select "option", value: CGI::escape_html(sponsor.city),
                                html: CGI::escape_html(sponsor.city)
      end

      assert_select "input#sponsor_new_city_name" do
        assert_select "[value]", false
      end

      assert_select "input#sponsor_address" do
        assert_select "[value=?]", CGI::escape_html(sponsor.address) if sponsor.address
      end

      assert_select "input#sponsor_email" do
        assert_select "[value=?]", CGI::escape_html(sponsor.email) if sponsor.email
      end

      assert_select "input#sponsor_contact1" do
        assert_select "[value=?]", CGI::escape_html(sponsor.contact1) if sponsor.contact1
      end

      assert_select "input#sponsor_contact2" do
        assert_select "[value=?]", CGI::escape_html(sponsor.contact2) if sponsor.contact2
      end

      assert_select "input#sponsor_additional_info" do
        assert_select "[value=?]", CGI::escape_html(sponsor.additional_info) if sponsor.additional_info
      end

      assert_select "select#sponsor_agent_id" do
        assert_select "option", value: sponsor.agent_id
        assert_select "option", html: CGI::escape_html(sponsor.agent.user_name) if sponsor.agent
      end

      assert_select "input", type: "submit"
    end

    specify "using a new Sponsor record" do
      assign :sponsor, new_sponsor
      render

      assert_select "input#sponsor_name" do
        assert_select "[value]", false
      end

      assert_select "input#sponsor_request_fulfilled", false

      assert_select "select#sponsor_sponsor_type_id" do
        assert_select "[disabled]", false
      end

      assert_select "select#sponsor_organization_id" do
        assert_select "[disabled]", false
      end

      assert_select "select#sponsor_branch_id" do
        assert_select "[disabled]", false
      end
    end

  end

end
