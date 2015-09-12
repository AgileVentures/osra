require 'rails_helper'

RSpec.feature 'OrphanList', :type => :feature do

  background do
    given_partners_exist [ { name: 'Partner1', status: 'Active', province: 'Damascus & Rif Dimashq' } ]
    i_sign_in_as_admin
  end

  scenario 'Upload valid orphan_list' do
    visit_partner 'Partner1'
    and_i_should_see_link "Upload Orphan List"
  end


  def visit_partner partner_name
    visit hq_partners_path
    and_i_should_see partner_name
    click_link partner_name
    and_i_should_be_on :hq_partner_page, { partner_name: partner_name }
  end


end



