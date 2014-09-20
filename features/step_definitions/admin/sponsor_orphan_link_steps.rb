Given(/^a sponsor "([^"]*)" exists$/) do |sponsor_name|
  FactoryGirl.create :sponsor, name: sponsor_name
end

Given(/^the sponsor "([^"]*)" has attribute (.*) "([^"]*)"$/) do |sponsor_name, attr, value|
  sponsor = Sponsor.find_by_name(sponsor_name)
  sponsor.update_attribute(attr, value)
end

Given(/^an orphan "([^"]*)" exists$/) do |orphan_name|
  FactoryGirl.create :orphan, name: orphan_name
end

Given(/^a sponsorship link exists between sponsor "([^"]*)" and orphan "([^"]*)"$/) do |sponsor_name, orphan_name|
  sponsor = Sponsor.find_by_name sponsor_name
  orphan = Orphan.find_by_name orphan_name
  sponsor.sponsorships.create!(orphan_id: orphan.id)
end

Then(/^show me the page$/) do
  save_and_open_page
end

Given /^PENDING/ do
  pending
end

When(/I click the "([^"]*)" link for orphan "([^"]*)"/) do |link, orphan|
  # Brittle & not flexible!
  case orphan
    when 'First Orphan' then
      tr_id = 'tr#orphan_1'
    when 'Second Orphan' then
      tr_id = 'tr#orphan_2'
    else
      raise 'Orphan not listed'
  end
  within(tr_id) { click_link link }
end
