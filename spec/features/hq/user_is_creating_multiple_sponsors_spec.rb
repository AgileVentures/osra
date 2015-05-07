require 'rails_helper'

RSpec.feature 'User enters new sponsor data', :type => :feature do

  background do
    an_agent_exists
    i_sign_in_as_admin
  end

  scenario 'User clicks the Create and Add Another button' do
    when_i_enter_new_sponsor_info
    and_i_click_create_and_add_another_button

    then_the_sponsor_should_be_saved
    and_i_should_be_on_new_sponsor_page
  end
end


def an_agent_exists
  FactoryGirl.create :agent
end

def when_i_enter_new_sponsor_info
  visit new_hq_sponsor_path
  fill_in 'Name', with: 'C. Montgomery Burns'
  fill_in 'Requested orphan count', with: '1'
  select 'London', from: 'sponsor[branch_id]'
  fill_in 'New city name', with: 'London'
  select User.first.user_name, from: 'sponsor[agent_id]'
end

def and_i_click_create_and_add_another_button
  click_button 'Create and Add Another'
end

def then_the_sponsor_should_be_saved
  expect(page).to have_text 'Sponsor successfuly created'
  expect(Sponsor.last.name).to eq 'C. Montgomery Burns'
end

def and_i_should_be_on_new_sponsor_page
  expect(current_path).to eq new_hq_sponsor_path
end
