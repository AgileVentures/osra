require 'rails_helper'
require 'spec_helper'

RSpec.feature 'Navigation menu', :type => :feature do

  background do
    i_sign_in_as_admin
  end
  scenario 'user click on OSRA link' do
    pending( "waiting for index path implementation" )
    within "#main_nav_bar" do
      click_link "OSRA"
    end
    expect(page).to eq index_path
  end
  scenario 'user click on Dashboard nav link' do
    within "#main_nav_bar" do
      click_link "Dashboard"
    end

    expect(page.current_path).to eq dashboard_index_path
  end

  scenario 'user click on Admin Users link' do
    within "#main_nav_bar" do
      click_link "Admin User"
    end
    expect(page.current_path).to eq admin_users_path
  end

  scenario 'user click on Orphans link' do
    within "#main_nav_bar" do
      click_link "Orphans"
    end
    expect(page.current_path).to eq orphans_path
  end

  scenario 'user click on Partners link' do
    within "#main_nav_bar" do
      click_link "Partners"
    end
    expect(page.current_path).to eq partners_path
  end

  scenario 'user click on Sponsors' do
    within "#main_nav_bar" do
      click_link "Sponsors"
    end
    expect(page.current_path).to eq sponsors_path
  end

  scenario 'user click on Users' do
    within "#main_nav_bar" do
      click_link "Users"
    end
    expect(page.current_path).to eq users_path
  end
end
