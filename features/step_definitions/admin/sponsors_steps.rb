Given(/^the following sponsors exist:$/) do |table|
  table.hashes.each do |hash|
    sponsor_type = SponsorType.find_or_create_by!(name: hash[:sponsor_type],
                                                  code: hash[:sponsor_type_code])
    sponsor = Sponsor.new(name: hash[:name], country: hash[:country], 
                          gender: hash[:gender], sponsor_type: sponsor_type) 
    sponsor.save!
  end
end

Then(/^I should see "Sponsors" linking to the admin sponsors page$/) do
  expect(page).to have_link("Sponsors", href: "#{admin_sponsors_path}")
end

When(/^I (?:go to|am on) the "([^"]*)" page for sponsor "([^"]*)"$/) do |page, sponsor_name|
  sponsor = Sponsor.find_by name: sponsor_name
  visit path_to_admin_role(page, sponsor.id)
end

Then(/^I should be on the "(.*?)" page for sponsor "(.*?)"$/) do |page_name, sponsor_name|
  sponsor = Sponsor.find_by name: sponsor_name
  expect(current_path).to eq path_to_admin_role(page_name, sponsor.id)
end

