require 'rails_helper'
include ViewHelpers

RSpec.feature 'User views a filtered orphans list by using the filter form', :type => :feature do
  background do
    a_list_of_orphans_exists
    i_sign_in_as_admin
  end

  scenario 'User filters the orphans list' do
    when_i_fill_in_orphan_filter_form
    and_i_click_filter_button

    then_i_should_see_a_filtered_orphans_list
    and_i_should_see_filters_form_filled_for_orphan

    when_i_click_clear_filters_button
    then_i_should_see_filters_form_clear_for_orphan
  end
end

def a_list_of_orphans_exists
  FactoryGirl.create_list(:orphan_full, 5)
end

def when_i_fill_in_orphan_filter_form
  orphan_filter = FactoryGirl.build(:orphan_filter, orphan: Orphan.first)

  visit orphans_path

  within "#filters" do
    find("select[name='filters[name_option]']").find("option[value='#{orphan_filter[:name_option]}']").select_option
    fill_in "filters[name_value]", with: orphan_filter[:name_value]
    find("select[name='filters[father_given_name_option]']").find("option[value='#{orphan_filter[:father_given_name_option]}']").select_option
    fill_in "filters[father_given_name_value]", with: orphan_filter[:father_given_name_value]
    find("select[name='filters[family_name_option]']").find("option[value='#{orphan_filter[:family_name_option]}']").select_option
    fill_in "filters[family_name_value]", with: orphan_filter[:family_name_value]

    select orphan_filter[:gender], from: 'filters[gender]'
    select orphan_filter[:priority], from: 'filters[priority]'

    find("select[name='filters[province_code]']").find("option[value='#{orphan_filter[:province_code]}']").select_option
    find("select[name='filters[original_address_city]']").find("option", text: orphan_filter[:original_address_city]).select_option
    find("select[name='filters[sponsorship_status]']").find("option[value='#{orphan_filter[:sponsorship_status]}']").select_option
    find("select[name='filters[status]']").find("option[value='#{orphan_filter[:status]}']").select_option
    find("select[name='filters[orphan_list_partner_name]']").find("option", text: orphan_filter[:orphan_list_partner_name]).select_option
    find("select[name='filters[health_status]']").find("option", text: orphan_filter[:health_status]).select_option if orphan_filter[:health_status]

    fill_in 'filters[date_of_birth_from]', with: orphan_filter[:date_of_birth_from]
    fill_in 'filters[date_of_birth_until]', with: orphan_filter[:date_of_birth_until]
    fill_in 'filters[created_at_from]', with: orphan_filter[:created_at_from]
    fill_in 'filters[created_at_until]', with: orphan_filter[:created_at_until]
    fill_in 'filters[updated_at_from]', with: orphan_filter[:updated_at_from]
    fill_in 'filters[updated_at_until]', with: orphan_filter[:updated_at_until]

    find("select[name='filters[father_is_martyr]']").find("option[value='#{orphan_filter[:father_is_martyr]}']").select_option
    find("select[name='filters[mother_alive]']").find("option[value='#{orphan_filter[:mother_alive]}']").select_option
    find("select[name='filters[goes_to_school]']").find("option[value='#{orphan_filter[:goes_to_school]}']").select_option
  end
end

def and_i_click_filter_button
  within "#filters" do
    click_button "Filter"
  end
end

def when_i_click_clear_filters_button
  within "#filters" do
    click_button "Clear Filters"
  end
end

def then_i_should_see_a_filtered_orphans_list
  expect(page.find("table[name='orphans']")).to have_text Orphan.first.name
  expect(page.find("table[name='orphans']")).to have_selector "tbody tr", count: 1
end

def and_i_should_see_filters_form_filled_for_orphan
  orphan_filter = FactoryGirl.build(:orphan_filter, orphan: Orphan.first)

  within "#filters" do
    #text fields
    [:name_value, :father_given_name_value, :family_name_value,
     :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
     :date_of_birth_from, :date_of_birth_until].each do |field|
      expect(page).to have_selector("input[name='filters[#{field.to_s}]'][value=\"#{orphan_filter[field]}\"]")
    end

    #select fields
    expect(page).to have_select("filters[gender]", selected: orphan_filter[:gender])
    expect(page.find("select[name='filters[priority]']"))
        .to have_selector("option[value='#{orphan_filter[:priority]}'][selected]")
    expect(page.find("select[name='filters[province_code]']"))
        .to have_selector("option[value='#{orphan_filter[:province_code]}'][selected]")
    expect(page.find("select[name='filters[original_address_city]']"))
        .to have_selector("option[value=\"#{orphan_filter[:original_address_city]}\"][selected]")

    expect(page).to have_select("filters[orphan_list_partner_name]",
                                selected: orphan_filter[:orphan_list_partner_name])
    expect(page.find("select[name='filters[sponsorship_status]']")).to have_selector("option[value='#{orphan_filter[:sponsorship_status]}']")
    expect(page.find("select[name='filters[status]']")).to have_selector("option[value='#{orphan_filter[:status]}']")
    expect(page).to have_select("filters[health_status]",
                                selected: orphan_filter[:health_status]) if orphan_filter[:health_status]

    expect(page).to have_select("filters[name_option]", selected: "Equals")
    expect(page).to have_select("filters[father_given_name_option]", selected: "Equals")
    expect(page).to have_select("filters[family_name_option]", selected: "Equals")
    expect(page).to have_select("filters[father_is_martyr]", selected: (orphan_filter[:father_is_martyr] ? "Yes" : "No"))
    expect(page).to have_select("filters[mother_alive]", selected: (orphan_filter[:mother_alive] ? "Yes" : "No"))
    expect(page).to have_select("filters[goes_to_school]", selected: (orphan_filter[:goes_to_school] ? "Yes" : "No")) if not orphan_filter[:goes_to_school].nil?
  end
end

def then_i_should_see_filters_form_clear_for_orphan
  within "#filters" do
    #text fields
    [:name_value, :father_given_name_value, :family_name_value,
     :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
     :date_of_birth_from, :date_of_birth_until ].each do |field|
      expect(page).to have_selector("input[name='filters[#{field.to_s}]']")
      expect(page).to_not have_selector("input[name='filters[#{field.to_s}]'][value]")
    end

    #select fields
    [:name_option, :father_given_name_option, :gender, :province_code, :sponsorship_status,
     :status, :father_is_martyr, :mother_alive, :goes_to_school, :original_address_city,
     :priority, :orphan_list_partner_name, :health_status]. each do |field|
      expect(page).to have_selector("select[name='filters[#{field.to_s}]']")
      expect(page.find("select[name='filters[#{field.to_s}]']")).to_not have_selector("option[selected]")
    end
  end
end
