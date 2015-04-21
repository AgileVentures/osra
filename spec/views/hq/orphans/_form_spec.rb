require 'rails_helper'
require 'cgi'

RSpec.describe "hq/orphans/_form.html.erb", type: :view do

  let(:orphan_statuses) { OrphanStatus.all }
  let(:orphan_sponsorship_statuses) { OrphanSponsorshipStatus.all }
  let(:provinces) { Province.all }
  let(:orphan_full) do
    build_stubbed :orphan_full
  end

  def render_orphan_form current_orphan
        render partial: 'hq/orphans/form.html.erb',
                        locals: { orphan: current_orphan,
                                  orphan_statuses: orphan_statuses,
                                  orphan_sponsorship_statuses: orphan_sponsorship_statuses,
                                  provinces: provinces
                                }
  end

  specify 'has a form' do
    render_orphan_form orphan_full

    assert_select 'form'
  end

  specify 'has a "Cancel" button' do
    render_orphan_form orphan_full

    assert_select 'a[href=?]', hq_orphan_path(orphan_full.id), text: 'Cancel'
  end

  specify 'has form values' do
    render_orphan_form orphan_full

    #textfields
    ["name", "father_given_name", "family_name", "mother_name", 
     "date_of_birth", "minor_siblings_count", 
     "sponsored_minor_siblings_count", "contact_number", 
     "health_status", "schooling_status", "created_at", "updated_at",
     "father_occupation", "father_place_of_death", 
     "father_cause_of_death", "father_date_of_death",
     "guardian_name", "guardian_relationship", 
     "guardian_id_num", "alt_contact_number", "comments"].each do |field|
      assert_select "input#orphan_#{field}" do
        if orphan_full[field]
          assert_select "[value=?]", CGI::escape_html(orphan_full[field].to_s)
        else
          assert_select "[value]", false
        end
      end
    end

    #checkboxes
    ["father_deceased", "mother_alive", "father_is_martyr",
     "sponsored_by_another_org", "goes_to_school"].each do |field|
      assert_select "input#orphan_#{field}" do
        assert_select "[checked]", orphan_full[field]
      end
    end
    
    assert_select "select#orphan_gender" do
      assert_select "option", value: Settings.lookup.gender.first,
                               html: CGI::escape_html(Settings.lookup.gender.first)
    end

    assert_select "select#orphan_orphan_status_id" do
      assert_select "option", value: orphan_statuses.first.id,
                               html: CGI::escape_html(orphan_statuses.first.name)
    end
  
    assert_select "select#orphan_orphan_sponsorship_status_id" do
      assert_select "option", value: orphan_sponsorship_statuses.first.id,
                               html: CGI::escape_html(orphan_sponsorship_statuses.first.name)
    end

    assert_select "select#orphan_priority" do
      assert_select "option", value: %w(Normal High).first,
                               html: CGI::escape_html(%w(Normal High).first)
    end

    assert_select "input#orphan_original_address_attributes_city" do
      assert_select "[value=?]", orphan_full.original_address.city
    end

    assert_select "select#orphan_original_address_attributes_province_id" do
      assert_select "option", value: provinces.first.id,
                               html: CGI::escape_html(provinces.first.name)
    end

    assert_select "input#orphan_original_address_attributes_neighborhood" do
      assert_select "[value=?]", orphan_full.original_address.neighborhood
    end

    assert_select "input#orphan_original_address_attributes_street" do
      assert_select "[value=?]", orphan_full.original_address.street
    end

    assert_select "input#orphan_original_address_attributes_details" do
      assert_select "[value=?]", orphan_full.original_address.details
    end

    assert_select "input#orphan_current_address_attributes_city" do
      assert_select "[value=?]", orphan_full.current_address.city
    end

    assert_select "select#orphan_current_address_attributes_province_id" do
      assert_select "option", value: provinces.first.id,
                               html: CGI::escape_html(provinces.first.name)
    end

    assert_select "input#orphan_current_address_attributes_neighborhood" do
      assert_select "[value=?]", orphan_full.current_address.neighborhood
    end

    assert_select "input#orphan_current_address_attributes_street" do
      assert_select "[value=?]", orphan_full.current_address.street
    end

    assert_select "input#orphan_current_address_attributes_details" do
      assert_select "[value=?]", orphan_full.current_address.details
    end

    assert_select "input", type: "submit"
  end
end

