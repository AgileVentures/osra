require 'rails_helper'
include ViewHelpers

RSpec.feature 'User views a sorted orphans list by clicking the table headers', :type => :feature do
  background do
    an_unordered_list_of_orphans_exists
    i_sign_in_as_admin
  end

  scenario 'User can sort the orphans list' do
    visit orphans_path

    i_should_see_orphans_ordered_as ["Aaron", "Bob", "Carl", "John", "Tom"]
    and_i_click_link "Full Name"
    i_should_see_orphans_ordered_as ["Tom", "John", "Carl", "Bob", "Aaron"]

    and_i_click_link "Date Of Birth"
    i_should_see_orphans_ordered_as ["John", "Tom", "Bob", "Carl", "Aaron"]
    and_i_click_link "Date Of Birth"
    i_should_see_orphans_ordered_as ["Aaron", "Carl", "Bob", "Tom", "John"]
    and_i_click_link "Date Of Birth"
    i_should_see_orphans_ordered_as ["John", "Tom", "Bob", "Carl", "Aaron"]
  end
end

def an_unordered_list_of_orphans_exists
  FactoryGirl.create(:orphan, name: "Carl", date_of_birth: "14 April 2015")
  FactoryGirl.create(:orphan, name: "Aaron", date_of_birth: "15 April 2015")
  FactoryGirl.create(:orphan, name: "Tom", date_of_birth: "12 April 2015")
  FactoryGirl.create(:orphan, name: "John", date_of_birth: "11 April 2015")
  FactoryGirl.create(:orphan, name: "Bob", date_of_birth: "13 April 2015")
end

def i_should_see_orphans_ordered_as names_order
  within "tbody" do
    all("tr").each_with_index do |tr, index|
      expect(tr).to have_content names_order[index]
    end
  end
end
