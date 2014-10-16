Given(/^the following partners exist:$/) do |table|
  table.hashes.each do |hash|
    status = Status.find_or_create_by(name: hash[:status], code: hash[:status_code])
    province = Province.find_or_create_by!(name: hash[:province],
                                           code: hash[:province_code]) 
    partner = Partner.new(name: hash[:name], 
                          region: hash[:region], 
                          start_date: hash[:start_date],
                          contact_details: hash[:contact_details],
                          province: province,
                          status: status)
    partner.save!
  end
end

Then(/^I should see "Partners" linking to the admin partners page$/) do
  expect(page).to have_link("Partners", href: "#{admin_partners_path}")
end

When(/^I (?:go to|am on) the "([^"]*)" page for partner "([^"]*)"$/) do |page, partner_name|
  partner = Partner.find_by name: partner_name
  visit path_to_admin_role(page, partner.id)
end

Then(/^I should be on the "(.*?)" page for partner "(.*?)"$/) do |page_name, partner_name|
  partner = Partner.find_by name: partner_name
  expect(current_path).to eq path_to_admin_role(page_name, partner.id)
end

Then(/^I should see the following codes for partners:$/) do |table|
  table.hashes.each do |hash|
    partner = Partner.find_by_name hash[:name]
    expect(partner.osra_num).to eq(hash[:expected_code])
    within "#partner_#{partner.id} .col-osra_num" do
      expect(page).to have_content(hash[:expected_code])
    end
  end
end

Then(/^I should not be able to change "Province"$/) do
  expect(find('#partner_province_id')['disabled']).to eq 'disabled'
  end

Then(/^I should not be able to change "OSRA num" for this (partner|orphan|sponsor)$/) do |model|
  expect(find("##{model}_osra_num")['readonly']).to eq 'readonly'
end
