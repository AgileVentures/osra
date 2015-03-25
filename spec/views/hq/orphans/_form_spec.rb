require 'rails_helper'
require 'cgi'

RSpec.describe "hq/orphans/_form.html.erb", type: :view do
  before :each do
    @orphan_statuses = OrphanStatus.all
    @orphan_sponsorship_statuses = OrphanSponsorshipStatus.all
    @provinces = Province.all
    @orphan = build_stubbed :orphan
  end

  specify 'has a form' do
    render

    assert_select 'form'
  end

  describe '"Cancel" button' do
    specify 'when :id' do
      allow(@orphan).to receive(:id).and_return 42
      render

      assert_select 'a[href=?]', hq_orphan_path(42), text: 'Cancel'
    end
  end

  specify 'form values' do
    render

    #fextfields
    ["name", "father_given_name", "family_name", "mother_name", "date_of_birth",
     "minor_siblings_count", "sponsored_minor_siblings_count"].each do |field|
      assert_select "input#orphan_#{field}" do
        assert_select "[value=?]", CGI::escape_html(@orphan[field].to_s)
      end
    end

    #checkboxes
    ["father_alive", "mother_alive", "father_is_martyr",
     "sponsored_by_another_org"].each do |field|
      assert_select "input#orphan_#{field}" do
        assert_select "[checked]", @orphan[field]
      end
    end

    assert_select "select#orphan_gender" do
      assert_select "option", value: Settings.lookup.gender.first,
                               html: CGI::escape_html(Settings.lookup.gender.first)
    end

    assert_select "select#orphan_orphan_status_id" do
      assert_select "option", value: @orphan_statuses.first.id,
                               html: CGI::escape_html(@orphan_statuses.first.name)
    end
  
    assert_select "select#orphan_orphan_sponsorship_status_id" do
      assert_select "option", value: @orphan_sponsorship_statuses.first.id,
                               html: CGI::escape_html(@orphan_sponsorship_statuses.first.name)
    end

    assert_select "select#orphan_priority" do
      assert_select "option", value: %w(Normal High).first,
                               html: CGI::escape_html(%w(Normal High).first)
    end

    assert_select "input#orphan_original_address_attributes_city" do
      assert_select "[value=?]", @orphan.original_address.city
    end

    assert_select "select#orphan_original_address_attributes_province_id" do
      assert_select "option", value: @provinces.first.id,
                               html: CGI::escape_html(@provinces.first.name)
    end

    assert_select "input#orphan_original_address_attributes_neighborhood" do
      assert_select "[value=?]", @orphan.original_address.neighborhood
    end

    assert_select "input#orphan_original_address_attributes_street" do
      assert_select "[value=?]", @orphan.original_address.street
    end

    assert_select "input#orphan_current_address_attributes_city" do
      assert_select "[value=?]", @orphan.current_address.city
    end

    assert_select "select#orphan_current_address_attributes_province_id" do
      assert_select "option", value: @provinces.first.id,
                               html: CGI::escape_html(@provinces.first.name)
    end

    assert_select "input#orphan_current_address_attributes_neighborhood" do
      assert_select "[value=?]", @orphan.current_address.neighborhood
    end

    assert_select "input#orphan_current_address_attributes_street" do
      assert_select "[value=?]", @orphan.current_address.street
    end

    assert_select "input", type: "submit"
  end
end

