require 'rails_helper'

RSpec.feature 'User enters new sponsor data', :type => :feature do

  background do
    i_sign_in_as_admin
  end

  scenario 'User clicks the New Sponsor button' do
    when_i_register_new_sponsor
    and_i_click_button 'Create Sponsor'

    then_the_sponsor_should_be_saved
    and_i_should_be_on :new_sponsor_page
  end

  def when_i_register_new_sponsor
    visit new_hq_sponsor_path
    t = Time.now + 5.days
    mDate = t.strftime("%Y-%m-%d")
    fill_in 'Name', with: 'Jack Napier'
    select 'Active', from: 'sponsor[status_id]'
    select 'Male', from: 'sponsor[gender]'
    fill_in 'Start date', with: '2015-06-01'
    fill_in 'Requested orphan count', with: '1'
    select 'Organization', from: 'sponsor[sponsor_type_id]'
    select 'أهل الغربة وقت الكربة', from: 'sponsor[organization_id]'
    select '(Afghanistan) أفغانستان', from: 'sponsor[country]'
    select '**Add New**', from: 'sponsor[city]'
    select 'Trisha Marquardt 1', from: 'sponsor[agent_id]'
  end

  def then_the_sponsor_should_be_saved
    expect(page).to have_content 'Sponsor successfuly created'
    expect(Sponsor.last.name).to eq 'Jack Napier'
  end
end
