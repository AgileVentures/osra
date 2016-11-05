require 'rails_helper'
include ViewHelpers

RSpec.feature 'User views a sorted partners list by clicking the table headers', :type => :feature do
  background do
    an_unordered_list_of_partners_exists
    i_sign_in_as_admin
  end

  scenario 'User can sort the partners list' do
    visit partners_path

    i_should_see_partners_ordered_as ["Aaron", "Bob", "Carl", "John", "Tom"]
    and_i_click_link "Name"
    i_should_see_partners_ordered_as ["Tom", "John", "Carl", "Bob", "Aaron"]

    and_i_click_link "Start Date"
    i_should_see_partners_ordered_as ["John", "Tom", "Bob", "Carl", "Aaron"]
    and_i_click_link "Start Date"
    i_should_see_partners_ordered_as ["Aaron", "Carl", "Bob", "Tom", "John"]
    and_i_click_link "Start Date"
    i_should_see_partners_ordered_as ["John", "Tom", "Bob", "Carl", "Aaron"]
  end
end

def an_unordered_list_of_partners_exists
  FactoryGirl.create(:partner, name: "Carl", start_date: "14 April 2015")
  FactoryGirl.create(:partner, name: "Aaron", start_date: "15 April 2015")
  FactoryGirl.create(:partner, name: "Tom", start_date: "12 April 2015")
  FactoryGirl.create(:partner, name: "John", start_date: "11 April 2015")
  FactoryGirl.create(:partner, name: "Bob", start_date: "13 April 2015")
end

def i_should_see_partners_ordered_as names_order
  within "tbody" do
    all("tr").each_with_index do |tr, index|
      expect(tr).to have_content names_order[index]
    end
  end
end
