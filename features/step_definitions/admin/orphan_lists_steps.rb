Given(/^I visit the new orphan list page for partner "([^"]*)"$/) do |partner|
  partner_id = Partner.find_by_name(partner).id
  visit upload_admin_partner_pending_orphan_lists_path(partner_id)
end

And(/^I upload the "([^"]*)" file$/) do |file|
  attach_file 'pending_orphan_list_spreadsheet', "spec/fixtures/#{file}"
end

Then(/^I should( not)? find pending orphan list "([^"]*)" in the database$/) do |negative, list|
  pending_list = PendingOrphanList.find_by_spreadsheet_file_name list
  negative ? (expect(pending_list).to eq nil) : (expect(pending_list).not_to eq nil)
end

And(/^I should find "([^"]*)" pending orphans for the "([^"]*)" list in the database$/) do |count, list|
  pending_list = PendingOrphanList.find_by_spreadsheet_file_name list
  if pending_list.nil?
    expect(count).to eq 0
  else
    expect(pending_list.pending_orphans.count).to eq count
  end
end

Given /^I have already uploaded the "([^"]*)" file for partner "([^"]*)"$/ do |file, partner|
  steps %Q{
    Given I visit the new orphan list page for partner "#{partner}"
    And I upload the "#{file}" file
    Then I click the "Upload" button
    Then I click the "Import" button
  }
end

And /^I try to upload the "([^"]*)" file for partner "([^"]*)"(?: again)?$/ do |file, partner|
  steps %Q{
    Given I have already uploaded the "#{file}" file for partner "#{partner}"
  }
end

Given /^I expect that importing the "([^"]*)" for "([^"]*)" does not change the count of "([^"]*)"$/ do |file, partner, objects|
  initial_count = objects.classify.constantize.all.count
  steps %Q{
    Given I have already uploaded the "#{file}" file for partner "#{partner}"
  }
  final_count = objects.classify.constantize.all.count
  expect(final_count).to eq initial_count
end
