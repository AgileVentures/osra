Given(/^a sponsor "([^"]*)" exists$/) do |sponsor_name|
  FactoryGirl.create :sponsor, name: sponsor_name
end

Given(/^an orphan "([^"]*)" exists$/) do |orphan_name|
  FactoryGirl.create :orphan, name: orphan_name
end

Given(/^a sponsorship link exists between sponsor "([^"]*)" and orphan "([^"]*)"$/) do |sponsor_name, orphan_name|
  sponsor = Sponsor.find_by_name sponsor_name
  orphan = Orphan.find_by_name orphan_name
  sponsor.sponsorships.create!(orphan_id: orphan.id, sponsorship_status: FactoryGirl.build_stubbed(:sponsorship_status))
end

Then(/^show me the page$/) do
  save_and_open_page
end
