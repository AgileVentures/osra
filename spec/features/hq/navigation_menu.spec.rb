require 'rails_helper'

RSpec.feature 'Navigation menu', :type => :feature do
    
  background do
    i_sign_in_as_admin
    visit hq_root_path
  end
  scenario 'user cilco on OSRA link' do
    and_i_click_a_link 'OSRA'
    expect(page).to have_content('Osra')   
  end
  scenario 'user click on Dashboard nav link' do
    and_i_click_a_link "Dashboard"
    expect(page).to have_css("img[src*='/images/osra_logo.jpg']")
    i_sign_out
    expect(page).not_to have_css("img[src*='/images/osra_logo.jpg']")
  end
  
  scenario 'user click on Admin Users link' do
    admin = FactoryGirl.create :admin_user
    and_i_click_a_link "Admin Users"
    and_i_should_see admin.email
    expect(page).to have_link('Edit')
    i_sign_out
    and_i_should_not_see admin.email
  end
  
  scenario 'user click on Orphans link' do
    orphan = FactoryGirl.create :orphan
    and_i_click_a_link 'Orphans'
    and_i_should_see orphan.name
    and_i_should_see orphan.partner.name
    expect(page).to have_link(orphan.name)
    expect(page).to have_link('All')
    expect(page).to have_link('Eligible For Sponsorship (1)')
    i_sign_out
    and_i_should_not_see orphan.name
  end
  
  scenario 'user click on Partners link' do
    partner = FactoryGirl.create :partner
    and_i_click_a_link 'Partners'
    and_i_should_see partner.name
    and_i_should_see partner.id
    expect(page).to have_link(partner.name)
    expect(page).to have_link('New Partner')
    i_sign_out
    and_i_should_not_see partner.name
  end
  
  scenario 'user click on Sponsors' do
    sponsor = FactoryGirl.create :sponsor
    and_i_click_a_link 'Sponsors'
    and_i_should_see sponsor.name
    and_i_should_see "Filters"
    expect(page).to have_link(sponsor.name)
    expect(page).to have_link('New Sponsor')
    i_sign_out
    and_i_should_not_see sponsor.name
  end
  
  scenario 'user click on Users' do
    user = FactoryGirl.create :user
    and_i_click_a_link 'Users'
    and_i_should_see user.email
    expect(page).to have_link(user.user_name)
    expect(page).to have_link('New User')
    i_sign_out
    and_i_should_not_see user.email
  end
end