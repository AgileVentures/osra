World Helpers

Given(/^I am a new, authenticated (?:user|visitor)$/) do
  create_admin_user
  login
end

Given(/^I am an unauthenticated (?:user|visitor)$/) do
  logout
end

Then(/^I should( not)? be able to access protected areas of the application$/) do |negative|
  visit path_to_admin_role("partners")
  if negative 
    expect(current_path).to eq path_to_admin_role("login")
  else 
    expect(current_path).to eq path_to_admin_role("partners") 
  end
end
