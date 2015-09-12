require 'rails_helper'

RSpec.feature 'OrphanList', :type => :feature do

  background do
    given_partners_exist [ { name: 'PartnerActive', status: 'Active', province: 'Damascus & Rif Dimashq' },
                           { name: 'PartnerInative', status: 'Inactive', province: 'Damascus & Rif Dimashq' } ]
    i_sign_in_as_admin
  end

  scenario "Uploading Orphan List for Active partner should be possible" do
    visit_partner 'PartnerActive'
    and_i_should_see_link "Upload Orphan List"
    and_i_click_link "Upload Orphan List"
    and_i_should_be_on :upload_hq_partner_pending_orphan_lists, { partner_name: 'PartnerActive' }
  end

  scenario "Uploading Orphan List for Inactive partner should be impossible" do
    visit_partner 'PartnerInative'
    and_i_should_see_link "Upload Orphan List"
    and_i_click_link "Upload Orphan List"
    and_i_should_be_on :hq_partner_page, { partner_name: 'PartnerInative' }
    and_i_should_see "Partner is not Active. Orphan List cannot be uploaded."
  end

  scenario 'Upload valid orphan_list for an active partner' do
    visit_partner 'PartnerActive'
    and_i_click_link "Upload Orphan List"
    and_i_should_be_on :upload_hq_partner_pending_orphan_lists, { partner_name: 'PartnerActive' }
    and_i_upload_valid_orphan_list
    and_i_should_see "Orphan list is valid"
    and_i_click_button "Import"
    and_i_should_be_on :hq_partner_page, { partner_name: 'PartnerActive' }
    and_i_should_see "Orphan List (0001) was successfully imported. Registered 3 new orphans."
  end


  def visit_partner partner_name
    visit hq_partners_path
    and_i_should_see partner_name
    and_i_click_link partner_name
    and_i_should_be_on :hq_partner_page, { partner_name: partner_name }
  end

  def and_i_upload_valid_orphan_list
    attach_file 'pending_orphan_list_spreadsheet', "spec/fixtures/three_orphans_xlsx.xlsx"
    and_i_click_button "Upload"
    and_i_should_be_on :validate_hq_partner_pending_orphan_lists, { partner_name: 'PartnerActive' }
  end

end



