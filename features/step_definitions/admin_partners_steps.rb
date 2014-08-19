Given(/^the following partners exist:$/) do |table|
  table.hashes.each do |hash|
    province = Province.find_or_create_by!(name: hash[:province],
                                           code: hash[:province_code]) 
    partner = Partner.new(name: hash[:name], 
                          region: hash[:region], 
                          province: province)
    partner.save!
  end
end

Then(/^I should see "Partners" linking to the admin partners page$/) do
  expect(page.has_link?("Partners", href: "#{admin_partners_path}")).to be_true
end

When(/^I (?:go to|am on) the "([^"]*)" page for partner "([^"]*)"$/) do |page, partner_name|
  partner = Partner.find_by name: partner_name
  visit path_to(page, partner.id)
end

Then(/^I should be on the "(.*?)" page for partner "(.*?)"$/) do |page_name, partner_name|
  partner = Partner.find_by name: partner_name
  expect(current_path).to eq path_to(page_name, partner.id)
end

