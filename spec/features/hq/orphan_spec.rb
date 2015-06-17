require 'rails_helper'

RSpec.feature 'Orphan CRUD spec:', :type => :feature do

  background do
    i_sign_in_as_admin
    an_orphan_exists 1, "Orphan 1", "Father 1", "2012-01-01", "Male", "Normal"
    an_orphan_exists 2, "Orphan 2", "Father 2", "2011-01-01", "Female", "High"
  end
  
  scenario 'There should be a list of orphans on the admin index page' do
    visit hq_orphans_path
    and_i_should_see "Orphan 1 Father 1"
    and_i_should_see "Orphan 2 Father 2"
    and_i_should_see_within "Orphan 1", "2012-01-01"
    and_i_should_see_within "Orphan 2", "High"
    and_i_should_see_within "Orphan 1", "Male"
    and_i_should_see_within "Orphan 2", "Female"
  end
  
  
  scenario 'Should not be able to create new orphans directly via the UI' do
    visit hq_orphans_path
    expect(page).to_not have_link 'New Orphan'
  end
  
  scenario 'Should be able to visit an orphan from the orphan index page' do
    visit hq_orphans_path
    when_i_click "Orphan 1", "Orphan 1"
    and_i_should_be_on "hq_orphan_path", { orphan_name: "Orphan 1" }
  end
  
  scenario 'Should be able to edit an orphan from the orphan show page' do
    visit_orphan( "Orphan 1" )
    and_i_click_link "Edit Orphan"
    and_i_should_be_on "edit_hq_orphan_path", { orphan_name: "Orphan 1" }
    expect(page).to_not have_selector '#osra_num'
    expect(page).to have_css '#orphan_sponsorship_status[disabled]'
    fill_in 'orphan[name]', with: 'Orphan N'
    fill_in 'orphan[date_of_birth]', with: '2010-01-01'
    fill_in 'orphan[father_given_name]', with: 'Father N'
    select "Female", :from => 'orphan[gender]'
    fill_in 'orphan[health_status]', with: 'Good'
    check 'orphan[goes_to_school]'
    select 'Inactive', :from => 'orphan[status]'
    select 'High', :from => 'orphan[priority]'
    fill_in 'orphan[family_name]', with: 'Asdf'
    fill_in 'orphan[mother_name]', with: 'Aisha'
    check 'orphan[mother_alive]'
    fill_in 'orphan[father_occupation]', with: 'Merchant'
    fill_in 'orphan[father_place_of_death]', with: 'Homs'
    fill_in 'orphan[father_cause_of_death]', with: 'Natural'
    fill_in 'orphan[father_date_of_death]', with: '2015-5-5'
    fill_in 'orphan[guardian_name]', with: 'Goku'
    fill_in 'orphan[guardian_id_num]', with: '999'
    fill_in 'orphan[guardian_name]', with: '999.999.999'
    fill_in 'orphan[alt_contact_number]', with: '000999'
    fill_in 'orphan_original_address_attributes_city', with: 'Rome'
    and_i_click_button "Update Orphan"
    and_i_should_be_on "hq_orphan_path", { orphan_name: 'Orphan N' }
    and_i_should_see "Orphan successfuly saved"
    and_i_should_see "Orphan N"
    and_i_should_see "01 January 2010"
    and_i_should_see 'Asdf'
    and_i_should_see 'Aisha'
    and_i_should_see 'Merchant'
    and_i_should_see 'Homs'
    and_i_should_see 'Natural'
    and_i_should_see '05 May 2015'
    and_i_should_see 'Rome'
    and_i_should_see '999'
    and_i_should_see '000999'
  end
  
  scenario 'Should not be able to delete an orphan from the orphan show page' do
    visit_orphan( "Orphan 1" )
    expect(page).to_not have_link 'Delete Orphan'
  end
  
  scenario 'Orphan cannot be older than 22 years of age' do
    visit_orphan( "Orphan 1" )
    and_i_click_link "Edit Orphan"
    and_i_should_be_on "edit_hq_orphan_path", { orphan_name: "Orphan 1" }
    fill_in 'orphan[date_of_birth]', with: '1950-01-01'
    and_i_click_button "Update Orphan"
    and_i_should_see "Date of birth Orphan must be younger than 22 years old to join OSRA."  
  end
  
  scenario 'Should return to orphan show page if editing an orphan is cancelled' do
    visit_orphan( "Orphan 1" )
    and_i_click_link "Edit Orphan"
    and_i_should_be_on "edit_hq_orphan_path", { orphan_name: "Orphan 1" }
    fill_in 'orphan[name]', with: 'Orphan N'
    and_i_click_link "Cancel"
    and_i_should_be_on "hq_orphan_path", { orphan_name: "Orphan 1" }
  end
  
  def when_i_click( link, orphan_name )
    orphan = Orphan.find_by_name orphan_name
    tr_id = "#orphan_#{orphan.id}"
    within(tr_id) { click_link link }
  end
  
  def an_orphan_exists( id, orphan_name, father_given_name,  birth_date, gender, priority )
    create :orphan, id: id, name: orphan_name, father_given_name: father_given_name, date_of_birth: birth_date, gender: gender, priority: priority
  end
  
  def and_i_should_see_within( panel, orphan_name )
    panel_id = "##{panel.parameterize('_')}"
    within(panel_id) { expect(page).to have_content orphan_name}
  end
  
  def visit_orphan( orphan_name )
    orphan = Orphan.find_by name: orphan_name
    visit hq_orphan_path orphan.id
  end

end