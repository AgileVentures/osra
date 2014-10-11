Given(/^I visit the new orphan list page for partner "([^"]*)"$/) do |partner|
  partner_id = Partner.find_by_name(partner).id
  visit upload_admin_partner_orphan_lists_path(partner_id)
end

And(/^I upload the "([^"]*)" file$/) do |file|
  attach_file 'pending_orphan_list_spreadsheet', "spec/fixtures/#{file}"
end

Then(/^I should( not)? find pending orphan list "([^"]*)" in the database$/) do |negative, list|
  pending_list = PendingOrphanList.find_by_spreadsheet_file_name list
  negative ? (expect(pending_list).to eq nil) : (expect(pending_list).not_to eq nil)
end