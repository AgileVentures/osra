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

Given(/^there are (#{A_NUMBER}) male and (#{A_NUMBER}) female (sponsor|orphan)[s]?$/) do |num_male, num_female, model|
  FactoryGirl.create_list(model, num_male, gender: 'Male')
  FactoryGirl.create_list(model, num_female, gender: 'Female')
  expect(model.capitalize.constantize.all.count).to eq num_male + num_female
end

When(/^I select "([^"]*)" from "([^"]*)"$/) do |option, selector|
  select option, from: "q_#{selector.parameterize}"
  click_button 'Filter'
end

Then(/^I should see only (fe)?male (sponsor|orphan)[s]?$/) do |fe, model|
  gender = fe ? 'Female' : 'Male'
  modelClass = model.capitalize.constantize
  objects = modelClass.where(gender: gender)
  objects.each do |obj|
    expect(page).to have_content obj.name
  end
end