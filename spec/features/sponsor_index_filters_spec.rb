require 'rails_helper'
include ViewHelpers

RSpec.feature 'User views a filtered sponsors list by using the filter form', :type => :feature do
  background do
    a_list_of_sponsors_exists
    i_sign_in_as_admin
  end

  scenario 'User filters the sponsors list' do
    when_i_fill_in_sponsor_filter_form
    and_i_click_filter_button

    then_i_should_see_a_filtered_sponsors_list
    and_i_should_see_filters_form_filled

    when_i_click_clear_filters_button
    then_i_should_see_filters_form_clear
  end
end

def a_list_of_sponsors_exists
  FactoryGirl.create_list(:sponsor, 5)
end

def when_i_fill_in_sponsor_filter_form
  sponsor_filter = FactoryGirl.build(:sponsor_filter, sponsor: Sponsor.first)
  visit sponsors_path

  within "#filters" do
    find("select[name='filters[name_option]']").find("option[value='#{sponsor_filter[:name_option]}']").select_option
    fill_in "filters[name_value]", with: sponsor_filter[:name_value]

    select sponsor_filter[:gender], from: 'filters[gender]'
    find("select[name='filters[branch_id]']").find("option[value='#{sponsor_filter[:branch_id]}']").select_option if sponsor_filter[:branch_id]
    find("select[name='filters[organization_id]']").find("option[value='#{sponsor_filter[:organization_id]}']").select_option if sponsor_filter[:organization_id]
    find("select[name='filters[status_id]']").find("option[value='#{sponsor_filter[:status_id]}']").select_option
    find("select[name='filters[sponsor_type_id]']").find("option[value='#{sponsor_filter[:sponsor_type_id]}']").select_option
    find("select[name='filters[agent_id]']").find("option[value='#{sponsor_filter[:agent_id]}']").select_option
    find("select[name='filters[country]']").find("option[value=\"#{sponsor_filter[:country]}\"]").select_option
    select sponsor_filter[:city], from: 'filters[city]'

    fill_in 'filters[created_at_from]', with: sponsor_filter[:created_at_from]
    fill_in 'filters[created_at_until]', with: sponsor_filter[:created_at_until]
    fill_in 'filters[updated_at_from]', with: sponsor_filter[:updated_at_from]
    fill_in 'filters[updated_at_until]', with: sponsor_filter[:updated_at_until]
    fill_in 'filters[start_date_from]', with: sponsor_filter[:start_date_from]
    fill_in 'filters[start_date_until]', with: sponsor_filter[:start_date_until]

    find("select[name='filters[request_fulfilled]']").find("option[value='#{sponsor_filter[:request_fulfilled]}']").select_option

    find("select[name='filters[active_sponsorship_count_option]']").find("option[value='#{sponsor_filter[:active_sponsorship_count_option]}']").select_option
    fill_in "filters[active_sponsorship_count_value]", with: sponsor_filter[:active_sponsorship_count_value]
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

def then_i_should_see_a_filtered_sponsors_list
  expect(page.find("table[name='sponsors']")).to have_text Sponsor.first.name
  expect(page.find("table[name='sponsors']")).to have_selector "tbody tr", count: 1
end

def and_i_should_see_filters_form_filled
  sponsor_filter = FactoryGirl.build(:sponsor_filter, sponsor: Sponsor.first)

  within "#filters" do
    #text fields
    [:name_value, :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
      :start_date_from, :start_date_until, :active_sponsorship_count_value].each do |field|
        expect(page).to have_selector("input[name='filters[#{field.to_s}]'][value=\"#{sponsor_filter[field]}\"]")
    end

    #select fields
    expect(page).to have_select("filters[gender]", selected: sponsor_filter[:gender])
    expect(page.find("select[name='filters[branch_id]']"))
        .to have_selector("option[value='#{sponsor_filter[:branch_id]}'][selected]") if sponsor_filter[:branch_id]
    expect(page.find("select[name='filters[organization_id]']"))
        .to have_selector("option[value='#{sponsor_filter[:organization_id]}'][selected]") if sponsor_filter[:organization_id]
    expect(page.find("select[name='filters[status_id]']"))
        .to have_selector("option[value='#{sponsor_filter[:status_id]}'][selected]")
    expect(page.find("select[name='filters[sponsor_type_id]']"))
        .to have_selector("option[value='#{sponsor_filter[:sponsor_type_id]}'][selected]")
    expect(page.find("select[name='filters[agent_id]']"))
        .to have_selector("option[value='#{sponsor_filter[:agent_id]}'][selected]")
    expect(page.find("select[name='filters[country]']"))
        .to have_selector("option[value=\"#{sponsor_filter[:country]}\"][selected]")
    expect(page).to have_select("filters[city]", selected: sponsor_filter[:city])

    expect(page).to have_select("filters[name_option]", selected: "Equals")
    expect(page).to have_select("filters[request_fulfilled]", selected: (sponsor_filter[:request_fulfilled] ? "Yes" : "No"))
    expect(page).to have_select("filters[active_sponsorship_count_option]", selected: "Equals")
  end
end

def then_i_should_see_filters_form_clear
  within "#filters" do
    #text fields
    [:name_value, :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
      :start_date_from, :start_date_until, :active_sponsorship_count_value].each do |field|
        expect(page).to have_selector("input[name='filters[#{field.to_s}]']")
        expect(page).to_not have_selector("input[name='filters[#{field.to_s}]'][value]")
    end

    #select fields
    [:name_option, :gender, :branch_id, :organization_id, :status_id, :sponsor_type_id, :agent_id, :country, :city, :request_fulfilled, :active_sponsorship_count_option]. each do |field|
      expect(page).to have_selector("select[name='filters[#{field.to_s}]']")
      expect(page.find("select[name='filters[#{field.to_s}]']")).to_not have_selector("option[selected]")
    end
  end
end
