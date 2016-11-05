require 'rails_helper'

RSpec.feature 'Orphan', :type => :feature do

  background do
    i_sign_in_as_admin
    an_orphan_exists 1, "Orphan 1", "Father 1", "family 1", "2012-01-01", "Male", "Normal"
    an_orphan_exists 2, "Orphan 2", "Father 2", "family 2", "2011-01-01", "Female", "High"
  end

  scenario 'There should be a list of orphans on the admin index page' do
    visit orphans_path
    and_i_should_see "Orphan 1 Father 1 family 1"
    and_i_should_see_within "Orphan 1", "Father 1 family 1"
    and_i_should_see_within "Orphan 1", "2012-01-01"
    and_i_should_see "Orphan 2 Father 2 family 2"
    and_i_should_see_within "Orphan 2", "Father 2 family 2"
    and_i_should_see_within "Orphan 2", "2011-01-01"
    and_i_should_see_within "Orphan 1", "2012-01-01"
    and_i_should_see_within "Orphan 2", "High"
    and_i_should_see_within "Orphan 1", "Male"
    and_i_should_see_within "Orphan 2", "Female"
  end


  scenario 'Should not be able to create new orphans directly via the UI' do
    visit orphans_path
    expect(page).to_not have_link 'New Orphan'
  end

  scenario 'Should be able to visit an orphan from the orphan index page' do
    visit orphans_path
    when_i_click "Orphan 1", "Orphan 1"
    and_i_should_be_on "orphan_page", { orphan_id: 1 }
  end

  scenario 'Should be inable to edit $osra_num field' do
    visit_orphan( "Orphan 1" )
    and_i_click_link "Edit Orphan"
    expect(page).to_not have_selector '#osra_num'
    expect(page).to have_css '#orphan_sponsorship_status[disabled]'
  end

  scenario 'Should be able to edit an orphan from the orphan show page' do
    # names of the input fields for text input
    fields = ['orphan[name]', 'orphan[date_of_birth]', 'orphan[father_given_name]', 'orphan[health_status]',
    'orphan[schooling_status]' ,'orphan[father_given_name]', 'orphan[family_name]', 'orphan[mother_name]',
    'orphan[father_occupation]', 'orphan[father_place_of_death]', 'orphan[father_cause_of_death]', 'orphan[father_date_of_death]',
    'orphan[guardian_name]', 'orphan[guardian_relationship]', 'orphan[guardian_id_num]', 'orphan[contact_number]',
    'orphan[alt_contact_number]', 'orphan[original_address_attributes][city]', 'orphan[original_address_attributes][neighborhood]',
    'orphan[original_address_attributes][street]', 'orphan[original_address_attributes][details]', 'orphan[current_address_attributes][city]',
    'orphan[current_address_attributes][neighborhood]','orphan[current_address_attributes][street]','orphan[current_address_attributes][details]',
    'orphan[minor_siblings_count]','orphan[sponsored_minor_siblings_count]', 'orphan[comments]']
    # inputs for the text fields
    inputs = ['Orphan N', '2010-01-01', 'Father N', 'Good', 'goes to school', 'Orphan Nxy', 'Asdf', 'Aisha',
    'Merchant', 'Gaza', 'natural', '2015-06-01', 'Goku', 'sister', '123', '321123', '000999', 'Rome', 'neighborhood',
    'infinite loop 1', 'Lorem Ipsum', 'New Town', 'NewTownHood','NewTownStreet','NewTown details', '10', '5', 'This is a comment' ]
    # expected output for the updated orphan
    output = ["Orphan successfuly saved", "Orphan N", "01 January 2010", 'Good', 'goes to school', 'Active', 'High',
    'Orphan Nxy', 'Asdf', 'Aisha', 'Merchant', 'Gaza', 'natural', '01 June 2015', 'Goku', 'sister', 'Rome', '123',
    '321123', '000999', 'Hama', 'neighborhood', 'infinite loop 1', 'Lorem Ipsum', 'New Town', 'Homs', 'NewTownHood',
    'NewTownStreet', 'NewTown details', 'Sponsored by Another Org. Yes', '10', '5', 'This is a comment']

    visit_orphan( "Orphan 1" )
    and_i_click_link "Edit Orphan"
    fill_in_multiple_fields fields, inputs

    select_multiple_options ['Female', 'Active', 'High', 'Hama', 'Homs'], ['orphan[gender]','orphan[status]','orphan[priority]',
    'orphan[original_address_attributes][province_id]', 'orphan[current_address_attributes][province_id]']

    select_multiple_check_box ['orphan[goes_to_school]', 'orphan[father_deceased]', 'orphan[mother_alive]', 'orphan[father_is_martyr]',
    'orphan[sponsored_by_another_org]']

    and_i_click_button "Update Orphan"
    and_i_should_be_on "orphan_page", { orphan_id: 1 }
    checks_multiple_fields output

  end

  scenario 'Should not be able to delete an orphan from the orphan show page' do
    visit_orphan( "Orphan 1" )
    expect(page).to_not have_link 'Delete Orphan'
  end

  scenario 'Orphan cannot be older than 22 years of age' do
    visit_orphan( "Orphan 1" )
    and_i_click_link "Edit Orphan"
    and_i_should_be_on "edit_orphan_page", { orphan_id: 1 }
    fill_in 'orphan[date_of_birth]', with: '1950-01-01'
    and_i_click_button "Update Orphan"
    and_i_should_see "Date of birth Orphan must be younger than 22 years old to join OSRA."
  end

  scenario 'Should return to orphan show page if editing an orphan is cancelled' do
    visit_orphan( "Orphan 1" )
    and_i_click_link "Edit Orphan"
    and_i_should_be_on "edit_orphan_page", { orphan_id: 1 }
    fill_in 'orphan[name]', with: 'Orphan N'
    and_i_click_link "Cancel"
    and_i_should_be_on "orphan_page", { orphan_id: 1 }
  end
  
  scenario 'export Orphans to csv' do
    visit orphans_path
    and_i_should_see "Export to csv"
  end

  def when_i_click( link, orphan_name )
    orphan = Orphan.find_by_name orphan_name
    tr_id = "#orphan_#{orphan.id}"
    within(tr_id) { click_link link }
  end

  def an_orphan_exists( id, orphan_name, father_given_name, family_name, birth_date, gender, priority )
    create :orphan, id: id, name: orphan_name, father_given_name: father_given_name, family_name: family_name, date_of_birth: birth_date, gender: gender, priority: priority
  end

  def and_i_should_see_within( panel, orphan_name )
    panel_id = "##{panel.parameterize('_')}"
    within(panel_id) { expect(page).to have_content orphan_name}
  end

  def visit_orphan( orphan_name )
    orphan = Orphan.find_by name: orphan_name
    visit orphan_path orphan.id
  end

  def fill_in_multiple_fields( fields, inputs )
    count = 0
    fields.each do |field|
      fill_in field, with: inputs[count]
      count += 1
    end
  end

  def checks_multiple_fields( outputs )
    outputs.each do |output|
      and_i_should_see output
    end
  end

  def select_multiple_options( options, fields )
    count = 0
    options.each do |option|
      select option, :from => fields[count]
      count += 1
    end
  end

  def select_multiple_check_box( fields )
    fields.each do |field|
      check field
    end
  end
end
