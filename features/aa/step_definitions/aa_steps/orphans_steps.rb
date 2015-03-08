Given(/^the following orphans exist:$/) do |table|
  table.hashes.each do |hash|
    orphan_list = FactoryGirl.create :orphan_list
    sponsorship_status = OrphanSponsorshipStatus.find_by_name(hash[:spon_status])
    original_province = Province.find_by_name(hash[:o_province])
    current_province = Province.find_by_name(hash[:c_province])
    original_address = Address.create(city: hash[:o_city], province: original_province,
                                      neighborhood: hash[:o_hood])
    current_address = Address.create(city: hash[:c_city], province: current_province,
                                     neighborhood: hash[:c_hood])

    orphan = Orphan.new(name: hash[:name],
                        father_given_name: hash[:father_given_name],
                        family_name: hash[:family_name],
                        orphan_sponsorship_status: sponsorship_status,
                        father_date_of_death: hash[:death_date], mother_name: hash[:mother],
                        date_of_birth: hash[:birth_date],
                        contact_number: hash[:contact],
                        original_address: original_address,
                        current_address: current_address,
                        mother_alive: true,
                        father_deceased: true,
                        gender: 'Female',
                        minor_siblings_count: 0,
                        father_is_martyr: true,
                        father_occupation: 'Some Occupation',
                        father_place_of_death: 'Some Place',
                        father_cause_of_death: 'Some Cause',
                        health_status: 'Some Health Status',
                        schooling_status: 'Some Schooling Status',
                        goes_to_school: true,
                        guardian_name: 'Some Name',
                        guardian_relationship: 'Some Relationship',
                        guardian_id_num: 12345,
                        alt_contact_number: 'Some Contact',
                        sponsored_by_another_org: false,
                        another_org_sponsorship_details: 'Some Details',
                        sponsored_minor_siblings_count: 0,
                        comments: 'Some Comments',
                        orphan_list: orphan_list)

    orphan.save!
  end
end

When(/^I (?:go to|am on) the "([^"]*)" page for orphan "([^"]*)"$/) do |page, orphan_name|
  orphan = Orphan.find_by name: orphan_name
  visit path_to_admin_role(page, orphan.id)
end

Then(/^I should be on the "(.*?)" page for orphan "(.*?)"$/) do |page_name, orphan_name|
  orphan = Orphan.find_by name: orphan_name
  expect(current_path).to eq path_to_admin_role(page_name, orphan.id)
end

And(/^I should see "([^"]*)" for "([^"]*)" set to "([^"]*)"$/) do |attr, orphan_name, value|
  orphan = Orphan.find_by_name(orphan_name)
  tr_id = ("#{orphan.class.name} #{orphan.id}").parameterize('_')
  col_class = attr.parameterize('_')
  field = within("tr##{tr_id}") { find("td.col-#{col_class}") }
  expect(field.text).to eq value
end

Then(/^I should see the OSRA number for "([^"]*)"$/) do |orphan_name|
  orphan = Orphan.find_by_name orphan_name
  expect(page).to have_content orphan.osra_num
end
