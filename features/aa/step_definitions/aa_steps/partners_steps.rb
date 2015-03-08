Given(/^the following partners exist:$/) do |table|
  table.hashes.each do |hash|
    status = Status.find_by_name(hash[:status])
    province = Province.find_by_name(hash[:province])
    partner = Partner.new(name: hash[:name], 
                          region: hash[:region], 
                          start_date: hash[:start_date],
                          contact_details: hash[:contact_details],
                          province: province,
                          status: status)
    partner.save!
  end
end

Given(/^"([^"]*)" has the following orphan lists?: (.*?)$/) do |partner_name, orphan_list_files|
  orphan_list_files.gsub('"','').split(', ').each do |file|
    steps %Q{
      Given I visit the new orphan list page for partner "#{partner_name}"
      And I upload the "#{file}" file
      Then I click the "Upload" button
      Then I click the "Import" button
    }
  end
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

Then(/^I should not be able to change "([^"]*)" for this ([^"]*)$/) do |field, obj|
  obj_to_param = obj.parameterize('_')
  obj_class = obj_to_param.classify.constantize
  associations = obj_class.reflect_on_all_associations.map{ |assoc| assoc.name.to_s }

  field_to_param = field.parameterize('_')
  css_selector = "##{obj_to_param}_#{field_to_param}"
  if associations.include? field_to_param
    css_selector = "#{css_selector}_id"
  end

  expect(find(css_selector)['readonly'] || find(css_selector)['disabled']).to be
end
