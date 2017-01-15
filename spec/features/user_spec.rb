require 'rails_helper'
RSpec.feature 'User', :type => :feature do

  background do
    i_sign_in_as_admin
    an_user_exist 98, 'Michael Knight', 'first@example.com'
    an_user_exist 99, 'Mitch Buchannon', 'second@example.com'
  end

  scenario 'There should be a list of users on the users index page' do
    visit users_path
    and_i_should_see 'Michael Knight'
    and_i_should_see 'first@example.com'
    and_i_should_see 'Mitch Buchannon'
    and_i_should_see 'second@example.com'
  end

  scenario 'The index page should show the number of active sponsors assigned to a user' do
    a_sponsorship_exist 98
    visit users_path
    and_i_should_see '1'
  end

  scenario 'Should be able to paginate active sponsors assigned to user' do
    allow(Sponsor).to receive(:per_page).and_return(1)
    create_active_sponsors(98, ['Active Sponsor 1', 'Active Sponsor 2'])
    create_inactive_sponsors(98, ['Inactive Sponsor 1', 'Inactive Sponsor 2'])
    visit users_path
    and_i_click_link 'Michael Knight'
    within('.active_sponsors_index') do
      click_on('Next')
    end
    and_i_should_not_see('Active Sponsor 2')
    and_i_should_see('Inactive Sponsor 2')
  end

  scenario 'Should be able to paginate inactive sponsors assigned to user' do
    allow(Sponsor).to receive(:per_page).and_return(1)
    create_active_sponsors(98, ['Active Sponsor 1', 'Active Sponsor 2'])
    create_inactive_sponsors(98, ['Inactive Sponsor 1', 'Inactive Sponsor 2'])
    visit users_path
    and_i_click_link 'Michael Knight'
    within('.inactive_sponsors_index') do
      click_on('Next')
    end
    and_i_should_not_see('Inactive Sponsor 2')
    and_i_should_see('Active Sponsor 2')
  end


  scenario 'It should be possible to visit a user from the users index page' do
    visit users_path
    and_i_click_link 'Michael Knight'
    and_i_should_be_on 'user_page', { user_id: 98 }
  end

  scenario 'Should be able to add a user from the users index page' do
    visit users_path
    and_i_click_link 'New User'
    and_i_should_be_on 'new_user_page'
    fill_in 'User name', with: 'New User'
    fill_in 'Email', with: 'new_user@example.com'
    click_button 'Create User'
    and_i_should_be_on 'user_page', { user_name: 'New User' }
    and_i_should_see 'User successfully created'
    and_i_should_see 'new_user@example.com'
  end

  scenario 'Should be able to edit a user from the user show page' do
    visit users_path
    and_i_click_link 'Michael Knight'
    and_i_click_link 'Edit User'
    and_i_should_be_on 'edit_user_page', { user_id: 98}
    fill_in 'Email', with: 'new_user@osra.org'
    and_i_click_button 'Update User'
    and_i_should_be_on 'user_page', { user_id: 98 }
    and_i_should_see 'User successfully saved'
    and_i_should_see 'new_user@osra.org'
  end

  scenario "Should be able to see links to assigned sponsors on a user's page" do
    a_sponsorship_exist 98
    visit users_path
    and_i_click_link 'Michael Knight'
    and_i_should_be_on 'user_page', { user_id: 98 }
    and_i_should_see '1 Active Sponsor'
    and_i_should_see '0 Inactive Sponsors'
    and_i_should_see 'Sponsor 1'
    and_i_click_link 'Sponsor 1'
    and_i_should_be_on 'sponsor_page', { sponsor_name: 'Sponsor 1' }
  end


  def an_user_exist( id, user_name, user_email )
    FactoryGirl.create :user, id: id, user_name: user_name, email: user_email
  end

  def a_sponsorship_exist( user_id )
      FactoryGirl.create :sponsor, agent_id: user_id, name: 'Sponsor 1'
  end

  def create_active_sponsors(user_id, names)
    names.each do |name|
      FactoryGirl.create(:sponsor, agent_id: user_id, name: name)
    end
  end

  def create_inactive_sponsors(user_id, names)
    inactive_status = Status.find_by_name('Inactive')
    names.each do |name|
      FactoryGirl.create(:sponsor, agent_id: user_id, name: name, status: inactive_status)
    end
  end
end
