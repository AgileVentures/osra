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

And(/^provinces and orphan statuses have been seeded$/) do
  Province.create(name: 'Damascus & Rif Dimashq', code: 11)
  Province.create(name: 'Aleppo', code: 12)
  Province.create(name: 'Homs', code: 13)
  Province.create(name: 'Hama', code: 14)
  Province.create(name: 'Latakia', code: 15)
  Province.create(name: 'Deir Al-Zor', code: 16)
  Province.create(name: 'Daraa', code: 17)
  Province.create(name: 'Idlib', code: 18)
  Province.create(name: 'Ar Raqqah', code: 19)
  Province.create(name: 'Al Ḥasakah', code: 20)
  Province.create(name: 'Tartous', code: 21)
  Province.create(name: 'Al-Suwayada', code: 22)
  Province.create(name: 'Al-Quneitera', code: 23)
  Province.create(name: 'Outside Syria', code: 29)
  OrphanStatus.create(name: 'Active', code: 1)
  OrphanStatus.create(name: 'Inactive', code: 2)
  OrphanStatus.create(name: 'On Hold', code: 3)
  OrphanStatus.create(name: 'Under Revision', code: 4)
  OrphanSponsorshipStatus.create(name: 'Unsponsored',          code: 1)
  OrphanSponsorshipStatus.create(name: 'Sponsored',            code: 2)
  OrphanSponsorshipStatus.create(name: 'Previously Sponsored', code: 3)
  OrphanSponsorshipStatus.create(name: 'On Hold',              code: 4)
end