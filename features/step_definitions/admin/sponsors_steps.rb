Given(/^the following sponsors exist:$/) do |table|
  table = table.transpose
  table.hashes.each do |hash|
    sponsor_type = SponsorType.find_by_name(hash[:sponsor_type])
    
    unless hash[:branch].blank?
      branch = Branch.find_by_name(hash[:branch]) ||
          FactoryGirl.create(:branch, name: hash[:branch])
    end

    unless hash[:organization].blank?
      organization = Organization.find_by_name(hash[:organization]) ||
          FactoryGirl.create(:organization, name: hash[:organization])
    end
    
    status= Status.find_by_name(hash[:status])
    
    sponsor = Sponsor.new(name: hash[:name], country: hash[:country],
                          gender: hash[:gender], sponsor_type: sponsor_type,
                          requested_orphan_count: hash[:requested_orphan_count],
                          address: hash[:address], email: hash[:email],
                          contact1: hash[:contact1], contact2: hash[:contact2],
                          additional_info: hash[:additional_info], branch: branch,
<<<<<<< HEAD
                          organization: organization,
=======
>>>>>>> 907c6d385911f142f9c64e1c581ff395ac42465f
                          start_date: hash[:start_date], status: status,
                          payment_plan: hash[:payment_plan])
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
