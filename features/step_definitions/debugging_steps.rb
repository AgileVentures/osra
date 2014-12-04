Then(/^show me the page$/) do
  save_and_open_page
end

Given /^PENDING/ do
  pending
end

Then(/^show me the orphans$/) do
  Orphan.all.each do |o|
    puts o.awesome_inspect
  end
end

Then(/^show me the provinces$/) do
  Province.all.each do |o|
    puts o.awesome_inspect
  end
end
