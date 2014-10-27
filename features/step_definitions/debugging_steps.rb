Then(/^show me the page$/) do
  save_and_open_page
end

Then(/^show me the orphans$/) do
  Orphan.all.each do |o|
    puts o.inspect
  end
end

Given /^PENDING/ do
  pending
end

