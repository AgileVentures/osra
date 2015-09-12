require 'rails_helper'

RSpec.feature 'OrphanList', :type => :feature do

  background do
    given_partners_exist [ { name: 'Partner1', status: 'Active', province: 'Damascus & Rif Dimashq' } ]
    i_sign_in_as_admin
  end

  scenario 'Upload valid orphan_list' do
    visit_partner 'Partner1'
    and_i_should_see_link "Upload Orphan List"
    and_i_click_link "Upload Orphan List"
    and_i_should_be_on :upload_hq_partner_pending_orphan_lists, { partner_name: 'Partner1' }
  end


  def visit_partner partner_name
    visit hq_partners_path
    and_i_should_see partner_name
    and_i_click_link partner_name
    and_i_should_be_on :hq_partner_page, { partner_name: partner_name }
  end


end



