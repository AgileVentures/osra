
Then(/^I should see a "([^"]*)" drop down box in the "Filters" section$/) do |selector|
  selector_id = "q_#{selector.parameterize}_id"
  within('div#filters_sidebar_section') { expect(page).to have_select selector_id }
end

Then(/^I should see a "([^"]*)" drop down box in the "Filters" section with options: (.*)$/) do |selector, options|
  selector_id = "q_#{selector.parameterize}"
  options_array = options.gsub(/"/, '').split(', ')
  within('div#filters_sidebar_section') do
    expect(page).to have_select(selector_id, with_options: options_array)
  end
end

Given(/^there are (#{A_NUMBER}) male sponsors and (#{A_NUMBER}) female sponsors$/) do |num_male, num_female|
  FactoryGirl.create_list(:sponsor, num_male, gender: 'Male')
  FactoryGirl.create_list(:sponsor, num_female, gender: 'Female')
  expect(Sponsor.all.count).to eq num_male + num_female
end

When(/^I select "([^"]*)" from "([^"]*)"$/) do |option, selector|
  select option, from: "q_#{selector.parameterize}"
  click_button 'Filter'
end

Then(/^I should see only (fe)?male sponsors$/) do |fe|
  gender = fe ? 'Female' : 'Male'
  sponsors = Sponsor.where(gender: gender)
  sponsors.each do |sponsor|
    expect(page).to have_content sponsor.name
  end
end
