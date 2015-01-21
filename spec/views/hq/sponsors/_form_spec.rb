require 'rails_helper'
require 'cgi'

RSpec.describe "hq/sponsors/_form.html.haml", type: :view do
  let(:user) { build_stubbed :user}
  let(:sponsor_full) do 
    build_stubbed :sponsor_full, agent: user,
                   request_fulfilled: [true, false].sample
  end
  let(:sponsor_new) { Sponsor.new }

  before :each do
    assign :sponsor, sponsor_full
    assign :statuses, Status.all
    assign :sponsor_types, SponsorType.all
    assign :organizations, Organization.all
    assign :branches, Branch.all
    assign :cities, [sponsor_full.city].unshift(Sponsor::NEW_CITY_MENU_OPTION)
  end

  specify 'has a form' do
    render

    assert_select 'form'
  end

  describe 'has a "Cancel" button' do
    specify 'using an existing Sponsor record' do
      allow(sponsor_full).to receive(:id).and_return sponsor_full.id
      render

      assert_select 'a[href=?]', hq_sponsor_path(sponsor_full.id), text: 'Cancel'
    end

    specify 'using a new Sponsor record' do
      allow(sponsor_full).to receive(:id).and_return nil
      render

      assert_select 'a[href=?]', hq_sponsors_path, text: 'Cancel'
    end
  end

  describe 'has form values' do
    specify 'using an existing Sponsor record' do
      allow(User).to receive(:pluck).and_return([user.user_name, user.id])
      render

      assert_select "input#sponsor_name" do
        assert_select "[value=?]", CGI::escape_html(sponsor_full.name)
      end

      assert_select "select#sponsor_status_id" do
        assert_select "option", value: sponsor_full.status_id,
                                html: CGI::escape_html(sponsor_full.status.name)
      end

      assert_select "select#sponsor_gender" do
        assert_select "option", value: Settings.lookup.gender.first,
                                html: CGI::escape_html(Settings.lookup.gender.first)
      end

      assert_select "input#sponsor_start_date" do
        assert_select "[value=?]", sponsor_full.start_date
      end

      assert_select "input#sponsor_requested_orphan_count" do
        assert_select "[value=?]", sponsor_full.requested_orphan_count
      end

      assert_select "input#sponsor_request_fulfilled" do
        assert_select "[disabled=?]", "disabled"
        assert_select "[value=?]", sponsor_full.request_fulfilled ? "1" : "0"
        assert_select "[checked]", true if sponsor_full.request_fulfilled
        assert_select "[checked]", false if !sponsor_full.request_fulfilled
      end

      assert_select "select#sponsor_sponsor_type_id" do
        assert_select "[disabled=?]", "disabled"
        assert_select "option", value: sponsor_full.sponsor_type_id,
          html: CGI::escape_html(sponsor_full.sponsor_type.name) do
            assert_select "[selected=?]", "selected"
        end
      end

      assert_select "select#sponsor_organization_id" do
        assert_select "[disabled=?]", "disabled"
        assert_select "option", value: sponsor_full.organization_id
        assert_select "option", 
            html: CGI::escape_html(sponsor_full.organization.name) if sponsor_full.organization
        assert_select "option", value: false if !sponsor_full.organization
      end

      assert_select "select#sponsor_branch_id" do
        assert_select "[disabled=?]", "disabled"
        assert_select "option", value: sponsor_full.branch_id
        assert_select "option", 
            html: CGI::escape_html(sponsor_full.branch.name) if sponsor_full.branch
        assert_select "option", value: false if !sponsor_full.branch
      end

      assert_select "select#sponsor_payment_plan" do
        assert_select "option", value: sponsor_full.payment_plan,   
                                html: CGI::escape_html(sponsor_full.payment_plan)
      end

      assert_select "select#sponsor_country" do
        assert_select "option", value: sponsor_full.country,
                                html: CGI::escape_html(en_ar_country sponsor_full.country)
      end

      assert_select "select#sponsor_city" do
        assert_select "option", value: CGI::escape_html(sponsor_full.city),
                                html: CGI::escape_html(sponsor_full.city)
      end

      assert_select "input#sponsor_new_city_name" do
        assert_select "[value]", false
      end

      assert_select "input#sponsor_address" do
        assert_select "[value=?]", 
            CGI::escape_html(sponsor_full.address) if sponsor_full.address
        assert_select "[value]", false if !sponsor_full.address
      end

      assert_select "input#sponsor_email" do
        assert_select "[value=?]", 
            CGI::escape_html(sponsor_full.email) if sponsor_full.email
        assert_select "[value]", false if !sponsor_full.email
      end

      assert_select "input#sponsor_contact1" do
        assert_select "[value=?]", 
            CGI::escape_html(sponsor_full.contact1) if sponsor_full.contact1
        assert_select "[value]", false if !sponsor_full.contact1
      end

      assert_select "input#sponsor_contact2" do
        assert_select "[value=?]", 
            CGI::escape_html(sponsor_full.contact2) if sponsor_full.contact2
        assert_select "[value]", false if !sponsor_full.contact2
      end

      assert_select "input#sponsor_additional_info" do
        assert_select "[value=?]", 
            CGI::escape_html(sponsor_full.additional_info) if sponsor_full.additional_info
        assert_select "[value]", false if !sponsor_full.additional_info
      end

      assert_select "select#sponsor_agent_id" do
        assert_select "option", value: sponsor_full.agent_id
        assert_select "option", 
            html: CGI::escape_html(sponsor_full.agent.user_name) if sponsor_full.agent
        assert_select "option", value: false if !sponsor_full.agent
      end

      assert_select "input", type: "submit"
    end

    specify "using a new Sponsor record" do
      assign :sponsor, sponsor_new
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
