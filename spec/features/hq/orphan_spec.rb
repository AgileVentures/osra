require 'rails_helper'

RSpec.feature 'Orphan CRUD spec:', :type => :feature do

  background do
    i_sign_in_as_admin
    an_orphan_exists 1, "Orphan 1", "Father 1", "2012-01-01", "Male", "Normal"
    an_orphan_exists 2, "Orphan 2", "Father 2", "2011-01-01", "Female", "High"
  end
  
  scenario 'There should be a list of orphans on the admin index page' do
    visit hq_orphans_path
    and_i_should_see "Orphan 1"
    and_i_should_see_within "Orphan 1", "Father 1"
    and_i_should_see_within "Orphan 1", "2012-01-01"
    and_i_should_see "Orphan 2"
    and_i_should_see_within "Orphan 2", "Father 2"
    and_i_should_see_within "Orphan 2", "2011-01-01"
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
    and_i_should_be_on "hq_orphan_path", { orphan_id: 1 }
  end
  
  scenario 'Should be able to edit an orphan from the orphan show page' do
    visit_orphan( "Orphan 1" )
    and_i_click_link "Edit Orphan"
    and_i_should_be_on "edit_hq_orphan_path", { orphan_id: 1 }
    expect(page).to_not have_selector '#osra_num'
    expect(page).to have_css '#orphan_sponsorship_status[disabled]'
    fill_in 'orphan[name]', with: 'Orphan N'
    fill_in 'orphan[date_of_birth]', with: '2010-01-01'
    fill_in 'orphan[father_given_name]', with: 'Father N'
    select "Female", :from => 'orphan[gender]'
    fill_in 'orphan[health_status]', with: 'Good'
    fill_in 'orphan[schooling_status]', with: 'goes to school'
    check 'orphan[goes_to_school]'
    select 'Active', :from => 'orphan[status]'
    select 'High', :from => 'orphan[priority]'
    fill_in 'orphan[father_given_name]', with: 'Orphan Nxy'
    fill_in 'orphan[family_name]', with: 'Asdf'
    check 'orphan[father_deceased]'
    fill_in 'orphan[mother_name]', with: 'Aisha'
    check 'orphan[mother_alive]'
    check 'orphan[father_is_martyr]'
    fill_in 'orphan[father_occupation]', with: 'Merchant'
    fill_in 'orphan[father_place_of_death]', with: 'Gaza'
    fill_in 'orphan[father_cause_of_death]', with: 'natural'
    fill_in 'orphan[father_date_of_death]', with: '2015-06-01'
    fill_in 'orphan[guardian_name]', with: 'Goku'
    fill_in 'orphan[guardian_relationship]', with: 'sister'
    fill_in 'orphan[guardian_id_num]', with: '123'
    fill_in 'orphan[contact_number]', with: '321123'
    fill_in 'orphan[alt_contact_number]', with: '000999'
    fill_in 'orphan[original_address_attributes][city]', with: 'Rome'
    select 'Hama', :from => 'orphan[original_address_attributes][province_id]'
    fill_in 'orphan[original_address_attributes][neighborhood]', with: 'neighborhood'
    fill_in 'orphan[original_address_attributes][street]', with: 'infinite loop 1'
    fill_in 'orphan[original_address_attributes][details]', with: 'Lorem Ipsum'
    fill_in 'orphan[current_address_attributes][city]', with: 'New Town'
    select 'Homs', :from => 'orphan[current_address_attributes][province_id]'
    fill_in 'orphan[current_address_attributes][neighborhood]', with: 'NewTownHood'
    fill_in 'orphan[current_address_attributes][street]', with: 'NewTownStreet'
    fill_in 'orphan[current_address_attributes][details]', with: 'NewTown details'
    check 'orphan[sponsored_by_another_org]'
    fill_in 'orphan[minor_siblings_count]', with: '10'
    fill_in 'orphan[sponsored_minor_siblings_count]', with: '5'
    fill_in 'orphan[comments]', with: 'This is a comment'
    and_i_click_button "Update Orphan"
    and_i_should_be_on "hq_orphan_path", { orphan_id: 1 }
    and_i_should_see "Orphan successfuly saved"
    and_i_should_see "Orphan N"
    and_i_should_see "01 January 2010"
    and_i_should_see 'Good'
    and_i_should_see 'goes to school'
    and_i_should_see 'Active'
    and_i_should_see 'High'
    and_i_should_see 'Orphan Nxy'
    and_i_should_see 'Asdf'
    and_i_should_see 'Aisha'
    and_i_should_see 'Merchant'
    and_i_should_see 'Gaza'
    and_i_should_see 'natural'
    and_i_should_see '01 June 2015'
    and_i_should_see 'Goku'
    and_i_should_see 'sister'
    and_i_should_see 'Rome'
    and_i_should_see '123'
    and_i_should_see '321123'
    and_i_should_see '000999'
    and_i_should_see 'Hama'
    and_i_should_see 'neighborhood'
    and_i_should_see 'infinite loop 1'
    and_i_should_see 'Lorem Ipsum'
    and_i_should_see 'New Town'
    and_i_should_see 'Homs'
    and_i_should_see 'NewTownHood'
    and_i_should_see 'NewTownStreet'
    and_i_should_see 'NewTown details'
    and_i_should_see 'Sponsored by Another Org. Yes'
    and_i_should_see '10'
    and_i_should_see '5'
    and_i_should_see 'This is a comment'
  end
  
  scenario 'Should not be able to delete an orphan from the orphan show page' do
    visit_orphan( "Orphan 1" )
    expect(page).to_not have_link 'Delete Orphan'
  end
  
  scenario 'Orphan cannot be older than 22 years of age' do
    visit_orphan( "Orphan 1" )
    and_i_click_link "Edit Orphan"
    and_i_should_be_on "edit_hq_orphan_path", { orphan_id: 1 }
    fill_in 'orphan[date_of_birth]', with: '1950-01-01'
    and_i_click_button "Update Orphan"
    and_i_should_see "Date of birth Orphan must be younger than 22 years old to join OSRA."  
  end
  
  scenario 'Should return to orphan show page if editing an orphan is cancelled' do
    visit_orphan( "Orphan 1" )
    and_i_click_link "Edit Orphan"
    and_i_should_be_on "edit_hq_orphan_path", { orphan_id: 1 }
    fill_in 'orphan[name]', with: 'Orphan N'
    and_i_click_link "Cancel"
    and_i_should_be_on "hq_orphan_path", { orphan_id: 1 }
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