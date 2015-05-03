require 'rails_helper'

RSpec.describe "hq/sponsors/filters.html.haml", type: :view do
  let(:sponsors_filters) {build :sponsor_filter, name_option: "equals", active_sponsorship_count_option: "greather_than"}

  it 'has a form' do
    render partial: "hq/sponsors/filters.html.haml", locals: {filters: {}}

    expect(rendered).to have_selector("form")
  end

  describe 'has form fields' do
    before :each do
      allow(Branch).to receive(:pluck).and_return(["branch1","branch2", sponsors_filters[:branch_id].to_s])
      allow(Organization).to receive(:pluck).and_return(["organization1","organization2", sponsors_filters[:organization_id].to_s])
      allow(Status).to receive(:pluck).and_return(["status1","status2", sponsors_filters[:status_id].to_s])
      allow(SponsorType).to receive(:pluck).and_return(["sponsor_type1","sponsor_type2", sponsors_filters[:sponsor_type_id].to_s])
      allow(User).to receive(:pluck).and_return(["agent1","agent2", sponsors_filters[:agent_id].to_s])
      allow(view).to receive(:country_options_for_select).and_return(["country1","country2", sponsors_filters[:country].to_s])
      allow(Sponsor).to receive_message_chain(:distinct, :pluck, :sort) {(["city1","city2", sponsors_filters[:city].to_s])}
    end

    specify "empty" do
      render partial: "hq/sponsors/filters.html.haml", locals: {filters: {}}

      #text fields
      ["name_value", "created_at_from", "created_at_until", "updated_at_from", "updated_at_until",
        "start_date_from", "start_date_until", "active_sponsorship_count_value"].each do |field|
        expect(rendered).to have_selector("input[id='filters_#{field}']")
        expect(rendered).to_not have_selector("input[id='filters_#{field}'][value]")
      end

      #select fields
      expect(rendered).to have_select("filters_name_option", options: ["Contains", "Equals", "Starts with", "Ends width"])
      expect(rendered).to have_select("filters_gender", options: ["Any"] + Settings.lookup.gender)
      expect(rendered).to have_select("filters_branch", options: ["Any","branch1","branch2", sponsors_filters[:branch_id].to_s])
      expect(rendered).to have_select("filters_organization", options: ["Any","organization1","organization2", sponsors_filters[:organization_id].to_s])
      expect(rendered).to have_select("filters_status", options: ["Any","status1","status2", sponsors_filters[:status_id].to_s])
      expect(rendered).to have_select("filters_sponsor_type", options: ["Any","sponsor_type1","sponsor_type2", sponsors_filters[:sponsor_type_id].to_s])
      expect(rendered).to have_select("filters_agent", options: ["Any","agent1","agent2", sponsors_filters[:agent_id].to_s])
      expect(rendered).to have_select("filters_country", options: ["Any","country1","country2", sponsors_filters[:country].to_s])
      expect(rendered).to have_select("filters_city", options: ["Any","city1", "city2", sponsors_filters[:city].to_s])
      expect(rendered).to have_select("filters_request_fulfilled", options: ["Any","Yes", "No"])
    end

    specify "filled" do
      render partial: "hq/sponsors/filters.html.haml", locals: {filters: sponsors_filters}

      #text fields
      [:name_value, :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
        :start_date_from, :start_date_until, :active_sponsorship_count_value].each do |field|
        expect(rendered).to have_selector("input[id='filters_#{field.to_s}'][value='#{sponsors_filters[field]}']") if sponsors_filters[field]
      end

      #select fields
      [:gender, :branch, :organization, :status, :sponsor_type, :agent, :country, :city].each do |field|
        expect(rendered).to have_select("filters_#{field.to_s}", selected: sponsors_filters[field]) if sponsors_filters[field]
      end
      expect(rendered).to have_select("filters_name_option", selected: "Equals")
      expect(rendered).to have_select("filters_request_fulfilled", selected: "No")
      expect(rendered).to have_select("filters_active_sponsorship_count_option", selected: "Greather than")
    end
  end

  it "has submit buttons" do
    render partial: "hq/sponsors/filters.html.haml", locals: {filters: {}}

    expect(rendered).to have_selector("input[type='submit'][value='Filter']")
    expect(rendered).to have_selector("input[type='submit'][value='Clear Filters']")
  end
end
