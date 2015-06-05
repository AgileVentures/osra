require 'rails_helper'

RSpec.feature 'User enters new sponsor data', :type => :feature do

  background do
    i_sign_in_as_admin
    an_agent_exists_with_username
  end

  scenario 'User clicks the New Sponsor button' do
    when_i_register_new_sponsor

    then_the_sponsor_should_be_saved
    and_i_should_be_on :hq_sponsor_path
  end

  def when_i_register_new_sponsor
    visit new_hq_sponsor_path
    t = Time.now + 5.days
    mDate = t.strftime("%Y-%m-%d")
    fill_in 'Name', with: 'Jack Napier'
    select 'Active', from: 'sponsor[status_id]'
    select 'Female', from: 'sponsor[gender]'
    fill_in 'Start date', with: mDate
    fill_in 'Requested orphan count', with: '1'
    select 'Organization', from: 'sponsor[sponsor_type_id]'
    select 'أهل الغربة وقت الكربة', from: 'sponsor[organization_id]'
    select '(Afghanistan) أفغانستان', from: 'sponsor[country]'
    select 'Sigurdland', from: 'sponsor[city]'
    select 'Trisha Marquardt 1', from: 'sponsor[agent_id]'
    click_button 'Create Sponsor'
  end

  def then_the_sponsor_should_be_saved
    expect(page).to have_content 'Sponsor successfuly created'
    expect(Sponsor.last.name).to eq 'Jack Napier'
  end
end
