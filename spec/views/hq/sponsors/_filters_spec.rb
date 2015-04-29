require 'rails_helper'

RSpec.describe "hq/sponsors/filters.html.haml", type: :view do
  it 'has a form' do
    render partial: "hq/sponsors/filters.html.haml"

    expect(rendered).to have_selector("form")
  end

  it 'has form fields' do
    allow(Branch).to receive(:pluck).and_return(["branch1","branch2"])
    allow(Organization).to receive(:pluck).and_return(["organization1","organization2"])
    allow(Status).to receive(:pluck).and_return(["status1","status2"])
    allow(SponsorType).to receive(:pluck).and_return(["sponsor_type1","sponsor_type2"])
    allow(User).to receive(:pluck).and_return(["agent1","agent2"])
    allow(view).to receive(:country_options_for_select).and_return(["country1","country2"])
    allow(Sponsor).to receive_message_chain(:distinct, :pluck, :sort) {(["city1","city2"])}

    render partial: "hq/sponsors/filters.html.haml"

    #text fields
    ["name_value", "created_at_from", "created_at_until", "updated_at_from", "updated_at_until",
      "start_date_from", "start_date_until", "active_sponsorship_count_value"].each do |field|
      expect(rendered).to have_selector("input[id='filters_#{field}']")
      expect(rendered).to_not have_selector("input[id='filters_#{field}'][value]")
    end

    #select fields
    expect(rendered).to have_select("filters_name_option", options: ["Contains", "Equals", "Starts with", "Ends width"])
    expect(rendered).to have_select("filters_gender", options: ["Any"] + Settings.lookup.gender)
    expect(rendered).to have_select("filters_branch", options: ["Any","branch1","branch2"])
    expect(rendered).to have_select("filters_organization", options: ["Any","organization1","organization2"])
    expect(rendered).to have_select("filters_status", options: ["Any","status1","status2"])
    expect(rendered).to have_select("filters_sponsor_type", options: ["Any","sponsor_type1","sponsor_type2"])
    expect(rendered).to have_select("filters_agent", options: ["Any","agent1","agent2"])
    expect(rendered).to have_select("filters_country", options: ["Any","country1","country2"])
    expect(rendered).to have_select("filters_city", options: ["Any","city1", "city2"])
    expect(rendered).to have_select("filters_request_fulfilled", options: ["Any","Yes", "No"])
    expect(rendered).to have_select("filters_active_sponsorship_count_option", options: ["Equals", "Greather than", "Less than"])
  end

  it "has submit buttons" do
    render partial: "hq/sponsors/filters.html.haml"

    expect(rendered).to have_selector("input[type='submit'][value='Filter']")
    expect(rendered).to have_selector("input[type='reset'][value='Clear Filters']")
  end
end