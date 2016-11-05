require 'rails_helper'

RSpec.feature 'OrphanList', :type => :feature do

  background do
    given_partners_exist [ { name: 'PartnerActive', status: 'Active', province: 'Damascus & Rif Dimashq' },
                           { name: 'PartnerInative', status: 'Inactive', province: 'Damascus & Rif Dimashq' } ]
    i_sign_in_as_admin
  end

  scenario "Active partners are allowed to upload orphan lists" do
    visit_partner 'PartnerActive'
    and_i_should_see_link "Upload Orphan List"
    and_i_click_link "Upload Orphan List"
    and_i_should_be_on :upload_partner_pending_orphan_lists, { partner_name: 'PartnerActive' }
  end

  scenario "Inactive partners are not allowed to upload orphan lists" do
    visit_partner 'PartnerInative'
    and_i_should_see_link "Upload Orphan List"
    and_i_click_link "Upload Orphan List"
    and_i_should_be_on :partner_page, { partner_name: 'PartnerInative' }
    and_i_should_see "Partner is not Active. Orphan List cannot be uploaded."
  end

  scenario 'Upload valid orphan_list for an active partner' do
    visit_partner 'PartnerActive'
    and_i_click_link "Upload Orphan List"
    and_i_should_be_on :upload_partner_pending_orphan_lists, { partner_name: 'PartnerActive' }

    and_i_upload_valid_orphan_list
    and_i_should_see "Orphan list is valid"
    and_i_click_button "Import"
    and_i_should_be_on :partner_page, { partner_name: 'PartnerActive' }
    and_i_should_see "Orphan List (0001) was successfully imported. Registered 3 new orphans."

    and_i_click_link "Orphan lists"
    and_i_should_be_on :partner_orphan_lists, { partner_name: 'PartnerActive' }
    and_i_should_see "three_orphans_xlsx.xlsx"
    and_i_should_not_see "No Orphan Lists found"

    and_i_click_link "Orphans"
    and_i_should_see_orphans
  end

  scenario 'Upload invalid orphan_list for an active partner' do
    visit_partner 'PartnerActive'
    and_i_click_link "Upload Orphan List"
    and_i_should_be_on :upload_partner_pending_orphan_lists, { partner_name: 'PartnerActive' }
    and_i_upload_invalid_orphan_list
    and_i_should_see "Orphan list is invalid"
    and_i_click_link "Cancel"
    and_i_should_be_on :partner_page, { partner_name: 'PartnerActive' }
  end

  scenario "OrphanList index view for partner without orphan lists" do
    visit_partner 'PartnerActive'
    and_i_click_link "Orphan lists"
    and_i_should_be_on :partner_orphan_lists, { partner_name: 'PartnerActive' }
    and_i_should_see "No Orphan Lists found"
  end


  def visit_partner partner_name
    visit partners_path
    and_i_should_see partner_name
    and_i_click_link partner_name
    and_i_should_be_on :partner_page, { partner_name: partner_name }
  end

  def and_i_upload_valid_orphan_list
    attach_file "pending_orphan_list_spreadsheet", "spec/fixtures/three_orphans_xlsx.xlsx"
    and_i_click_button "Upload"
    and_i_should_be_on :validate_partner_pending_orphan_lists, { partner_name: 'PartnerActive' }
  end

  def and_i_upload_invalid_orphan_list
    attach_file "pending_orphan_list_spreadsheet", "spec/fixtures/three_invalid_orphans_xlsx.xlsx"
    and_i_click_button "Upload"
    and_i_should_be_on :validate_partner_pending_orphan_lists, { partner_name: 'PartnerActive' }
  end

  def and_i_should_see_orphans
    expect(page).to have_selector "table[name='orphans'] tbody tr"
  end

  def and_i_should_see_disabled_button text
    expect(page).to have_selector "a[disabled][text='#{text}']"
  end

end
