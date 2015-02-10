Given(/^a sponsor "([^"]*)" exists$/) do |sponsor_name|
  FactoryGirl.create :sponsor, name: sponsor_name, requested_orphan_count: 5
end

Given(/^the sponsor "([^"]*)" has attribute (.*) "([^"]*)"$/) do |sponsor_name, attr, value|
  sponsor = Sponsor.find_by_name(sponsor_name)
  sponsor.update_attribute(attr, value)
end

Given(/^an orphan "([^"]*)" exists$/) do |orphan_name|
  FactoryGirl.create :orphan, name: orphan_name
end

Given(/^an (in)?active sponsorship link exists between sponsor "([^"]*)" and orphan "([^"]*)"$/) do |inactive, sponsor_name, orphan_name|
  sponsor = Sponsor.find_by_name(sponsor_name) || FactoryGirl.create(:sponsor, name: sponsor_name)
  orphan = Orphan.find_by_name(orphan_name) || FactoryGirl.create(:orphan, name: orphan_name)

  sponsorship = FactoryGirl.build :sponsorship, sponsor: sponsor, orphan: orphan
  CreateSponsorship.new(sponsorship).call

  if inactive
    future_date = sponsorship.start_date + 2.months
    InactivateSponsorship.new(sponsorship: sponsorship, end_date: future_date).call
  end
end

Given (/^"([^"]*)" started a sponsorship for "([^"]*)" on "([^"]*)"$/) do |sponsor_name, orphan_name, start_date|
  sponsor = Sponsor.find_by_name(sponsor_name) || FactoryGirl.create(:sponsor, name: sponsor_name)
  orphan = Orphan.find_by_name(orphan_name) || FactoryGirl.create(:orphan, name: orphan_name)

  sponsorship = FactoryGirl.build :sponsorship, sponsor: sponsor, orphan: orphan, start_date: start_date
  CreateSponsorship.new(sponsorship).call
end

When(/I click the "Sponsor this orphan" link for orphan "([^"]*)"/) do |orphan_name|
  orphan = Orphan.find_by_name orphan_name
  tr_id = "#orphan_#{orphan.id}"
  within(tr_id) { click_button 'Sponsor this orphan' }
end

When(/I click the "End sponsorship" link for orphan "([^"]*)"/) do |orphan_name|
  orphan = Orphan.find_by_name orphan_name
  sponsorship = Sponsorship.where(orphan_id: orphan.id, active: true).first
  tr_id = "#sponsorship_#{sponsorship.id}"
  within(tr_id) { click_button 'End Sponsorship' }
end

When(/^I fill in Sponsorship Start Date for "([^"]*)" with "([^"]*)"$/) do |orphan_name, value|
  orphan = Orphan.find_by_name orphan_name
  tr_id = "#orphan_#{orphan.id}"
  within(tr_id) { fill_in :sponsorship_start_date, with: value }
end

When(/^I fill in Sponsorship Start Date for "([^"]*)" with date in distant future$/) do |orphan_name|
  date = Date.current + 2.months
  steps %Q{ When I fill in Sponsorship Start Date for "First Orphan" with "#{date.to_s}" }
end

When(/^I fill in Sponsorship End Date for "([^"]*)" with date in distant future$/) do |orphan_name|
  date = Date.current + 2.months
  steps %Q{ When I fill in Sponsorship End Date for "First Orphan" with "#{date.to_s}" }
end

When(/^I fill in Sponsorship End Date for "([^"]*)" with "([^"]*)"$/) do |orphan_name, value|
  orphan = Orphan.find_by_name orphan_name
  sponsorship = Sponsorship.where(orphan_id: orphan.id, active: true).first
  tr_id = "#sponsorship_#{sponsorship.id}"
  within(tr_id) { fill_in :end_date, with: value }
end

When(/^I fill in "([^"]*)" with date in distant future for orphan "([^"]*)"$/) do |field, orphan_name|
  orphan = Orphan.find_by_name orphan_name
  sponsorship = Sponsorship.where(orphan_id: orphan.id, active: true).first
  tr_id = "#sponsorship_#{sponsorship.id}"
  future_date = Date.current + 2.months
  within(tr_id) { fill_in field, with: future_date }
end

Then(/I should( not)? see "([^"]*)" within "([^"]*)"/) do |negative, orphan_name, panel|
  panel_id = "##{panel.parameterize('_')}"

  if negative
    within(panel_id) { expect(page).not_to have_content orphan_name }
  else
    within(panel_id) { expect(page).to have_content orphan_name }
  end
end

Given(/^the status of sponsor "([^"]*)" is "([^"]*)"$/) do |sponsor_name, status|
  sponsor_status = Status.find_by_name(status)
  Sponsor.find_by_name(sponsor_name).update! status: sponsor_status
end

And(/^I should see "([^"]*)" linking to the sponsor's page$/) do |sponsor_name|
  sponsor = Sponsor.find_by_name sponsor_name
  expect(page).to have_link(sponsor_name, href: admin_sponsor_path(sponsor))
end

Given /^sponsor "([^"]*)" has requested to sponsor (\d+) orphans$/ do |sponsor_name, request|
  sponsor = Sponsor.find_by_name sponsor_name
  sponsor.update!(requested_orphan_count: request)
end

Given /^I have mistakenly created a sponsorship between "([^"]*)" and "([^"]*)"$/ do |sponsor_name, orphan_name|
  sponsor = FactoryGirl.create(:sponsor, name: sponsor_name, requested_orphan_count: 1)
  orphan = FactoryGirl.create(:orphan, name: orphan_name)
  @sponsor_original_state = [sponsor.request_fulfilled,
                             sponsor.active_sponsorship_count]
  @orphan_original_state = orphan.sponsorship_status
  sponsorship = FactoryGirl.build :sponsorship, sponsor: sponsor, orphan: orphan
  CreateSponsorship.new(sponsorship).call
end

And /^I destroy the record of the "([^"]*)" - "([^"]*)" sponsorship$/ do |sponsor_name, orphan_name|
  steps %Q{ When I am on the "Show Sponsor" page for sponsor "#{sponsor_name}" }
  orphan = Orphan.find_by_name(orphan_name)
  sponsorship = Sponsorship.where(orphan_id: orphan.id, active: true).first
  tr_id = "#sponsorship_#{sponsorship.id}"
  within(tr_id) { click_link 'X' }
end

Then /^sponsorship data for "([^"]*)" should reset$/ do |sponsor_name|
  sponsor = Sponsor.find_by_name(sponsor_name)
  sponsor_state = [sponsor.request_fulfilled, sponsor.active_sponsorship_count]
  expect(sponsor_state).to eq @sponsor_original_state
end

And /^sponsorship status for "([^"]*)" should reset$/ do |orphan_name|
  orphan = Orphan.find_by_name(orphan_name)
  expect(orphan.sponsorship_status).to eq @orphan_original_state
end
