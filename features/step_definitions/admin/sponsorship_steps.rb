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

Given(/^the orphan "([^"]*)" has attribute (.*) "([^"]*)"$/) do |orphan_name, attr, value|
  orphan = Orphan.find_by_name orphan_name
  orphan.update_attribute attr, value 
end

Given(/^the orphan "([^"]*)" has sponsorship_status "([^"]*)"$/) do |orphan_name, status_name|
  orphan = Orphan.find_by_name orphan_name
  status = OrphanSponsorshipStatus.find_by_name status_name
  orphan.orphan_sponsorship_status = status
  orphan.save!
end

Given(/^the orphan "([^"]*)" has the (.*)-lowest original_province$/) do |orphan_name, qualifier|
  orphan = Orphan.find_by_name orphan_name || raise("Cannot find orphan \"#{orphan_name}\"")
  orig_addr = orphan.original_address || raise("Cannot find original_address \"#{orphan.original_address}\"")
  unless ['first', 'second', 'third'].include? qualifier.to_s
    return raise "Qualifier needs to be one of ['first', 'second', 'third']"
  end
  #indx = 0
  #puts eval("[0, 1, 2].#{qualifier.to_s}.to_i")
  new_prov = Province.all.order('code ASC')[eval("[0, 1, 2].#{qualifier.to_s}.to_i")]
  orig_addr.province = new_prov || raise("Cannot change original_address \"#{orig_addr.province.name}\"")
  orig_addr.save!
end

Given(/^a(n inactive)? sponsorship link exists between sponsor "([^"]*)" and orphan "([^"]*)"$/) do |inactive, sponsor_name, orphan_name|
  sponsor = Sponsor.find_by_name sponsor_name
  orphan = Orphan.find_by_name orphan_name
  sponsorship = sponsor.sponsorships.create!(orphan_id: orphan.id)
  if inactive
    sponsorship.inactivate
  end
end

When(/I click the "Sponsor this orphan" link for orphan "([^"]*)"/) do |orphan_name|
  orphan = Orphan.find_by_name orphan_name
  tr_id = "#orphan_#{orphan.id}"
  within(tr_id) { click_link 'Sponsor this orphan' }
end

When(/I click the "End sponsorship" link for orphan "([^"]*)"/) do |orphan_name|
  orphan = Orphan.find_by_name orphan_name
  sponsorship = Sponsorship.where(orphan_id: orphan.id, active: true).first
  tr_id = "#sponsorship_#{sponsorship.id}"
  within(tr_id) { click_link 'End sponsorship' }
end

Then(/I should( not)? see "([^"]*)" within "([^"]*)"/) do |negative, orphan_name, panel|
  case panel
    when 'Currently Sponsored Orphans' then
      panel_id = '#active'
    when 'Previously Sponsored Orphans' then
      panel_id = '#inactive'
    else raise 'Element not found on page'
  end

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
