require 'rails_helper'

RSpec.describe "orphans/_form.html.erb", type: :view do

  let(:statuses) { Orphan.statuses.keys.map { |k| [k.humanize, k] } }
  let(:sponsorship_statuses) do
    Orphan.sponsorship_statuses.keys.map { |k| [k.humanize, k] }
  end
  let(:provinces) { Province.all }
  let(:orphan_full) do
    build_stubbed :orphan_full
  end

  def render_orphan_form current_orphan
        render partial: 'orphans/form.html.erb',
                        locals: { orphan: current_orphan,
                                  statuses: statuses,
                                  sponsorship_statuses: sponsorship_statuses,
                                  provinces: provinces
                                }
  end

  specify 'has a form' do
    render_orphan_form orphan_full

    expect(rendered).to have_selector("form")
  end

  specify 'has a "Cancel" button when using an existing Orphan record' do
    render_orphan_form orphan_full

    expect(rendered).to have_link("Cancel", orphan_path(orphan_full))
  end

  specify 'has form values' do
    render_orphan_form orphan_full

    #textfields
    ["name", "date_of_birth", "health_status",
     "schooling_status", "created_at", "updated_at",
     "father_given_name", "family_name", "mother_name",
     "father_occupation", "father_place_of_death",
     "father_cause_of_death", "father_date_of_death",
     "guardian_name", "guardian_relationship",
     "guardian_id_num", "contact_number", "alt_contact_number"].each do |field|
      if orphan_full[field]
        expect(rendered).to have_selector("input[id=\"orphan_#{field}\"][value=\"#{orphan_full[field]}\"]")
      else
        expect(rendered).to have_selector("input[id='orphan_#{field}']")
        expect(rendered).to_not have_selector("input[id='orphan_#{field}'][value]")
      end
    end

    #checkboxes
    ["goes_to_school", "father_deceased", "mother_alive", "father_is_martyr"].each do |field|
      if orphan_full[field]
        expect(rendered).to have_checked_field("orphan_#{field}")
      else
        expect(rendered).to have_unchecked_field("orphan_#{field}")
      end
    end

    #dropdowns
    expect(rendered).to have_select("orphan_gender", selected: orphan_full.gender,
                                 options: Settings.lookup.gender)

    expect(rendered).to have_select("orphan_status", selected: orphan_full.status.humanize,
                                    options: Orphan.statuses.keys.map(&:humanize))

    expect(rendered).to have_select('orphan_sponsorship_status',
                                    selected: orphan_full.sponsorship_status.humanize,
                                    options: Orphan.sponsorship_statuses.keys.map(&:humanize),
                                    disabled: true)
    #
    expect(rendered).to have_select("orphan_priority",
                             selected: orphan_full.priority,
                             options: %w(Normal High))

    # Original Address
    expect(rendered).to have_selector("input#orphan_original_address_attributes_city[value=\"#{orphan_full.original_address.city}\"]")
    expect(rendered).to have_select("orphan_original_address_attributes_province_id",
                              selected: orphan_full.original_address.province.name,
                              options: provinces.map(&:name))
    expect(rendered).to have_selector("input#orphan_original_address_attributes_neighborhood[value=\"#{orphan_full.original_address.neighborhood}\"]")
    expect(rendered).to have_selector("input#orphan_original_address_attributes_street[value=\"#{orphan_full.original_address.street}\"]")
    expect(rendered).to have_selector("input#orphan_original_address_attributes_details[value=\"#{orphan_full.original_address.details}\"]")

    # Current Address
    expect(rendered).to have_selector("input#orphan_current_address_attributes_city[value=\"#{orphan_full.current_address.city}\"]")
    expect(rendered).to have_select("orphan_current_address_attributes_province_id",
                          selected: orphan_full.current_address.province.name,
                          options: provinces.map(&:name))
    expect(rendered).to have_selector("input#orphan_current_address_attributes_neighborhood[value=\"#{orphan_full.current_address.neighborhood}\"]")
    expect(rendered).to have_selector("input#orphan_current_address_attributes_street[value=\"#{orphan_full.current_address.street}\"]")
    expect(rendered).to have_selector("input#orphan_current_address_attributes_details[value=\"#{orphan_full.current_address.details}\"]")

    # Additional Details
    if orphan_full.sponsored_by_another_org
      expect(rendered).to have_checked_field("orphan_sponsored_by_another_org")
    else
      expect(rendered).to have_unchecked_field("orphan_sponsored_by_another_org")
    end
    expect(rendered).to have_selector("input#orphan_minor_siblings_count[value=\"#{orphan_full.minor_siblings_count}\"]")
    expect(rendered).to have_selector("input#orphan_sponsored_minor_siblings_count[value=\"#{orphan_full.sponsored_minor_siblings_count}\"]")
    expect(rendered).to have_selector("input#orphan_comments[value=\"#{orphan_full.comments}\"]")

    #submit button
    expect(rendered).to have_selector("input[type='submit'][value='Update Orphan']")
  end

  describe 'required fields' do
    before(:each) { render_orphan_form orphan_full }

    it 'marks required fields' do
      expect(rendered).to mark_required_fields_for Orphan
    end

    it 'does not mark optional' do
      expect(rendered).not_to mark_optional_fields_for Orphan
    end
  end
end

