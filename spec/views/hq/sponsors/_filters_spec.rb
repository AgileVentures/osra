require 'rails_helper'

RSpec.describe "hq/sponsors/filters.html.haml", type: :view do
  let(:sponsors_filters) {{
    "name" => {
      "option": "equals",
      "value": Faker::Lorem.word
      },
    "gender": Settings.lookup.gender.sample,
    "branch": "branch2",
    "organization": "organization2",
    "status": "status2",
    "sponsor_type": "sponsor_type2",
    "agent": "agent2",
    "city": "city2",
    "country": "country2",
    "created_at" => {"from": Faker::Date.backward(999).to_s, "until": Faker::Date.backward(999).to_s},
    "updated_at" => {"from": Faker::Date.backward(999).to_s, "until": Faker::Date.backward(999).to_s},
    "start_date" => {"from": Faker::Date.backward(999).to_s, "until": Faker::Date.backward(999).to_s},
    "request_fulfilled": "false",
    "active_sponsorship_count" => {
      "option": "greather_than",
      "value": Faker::Number.digit.to_s
    }
  }.with_indifferent_access}

  it 'has a form' do
    render partial: "hq/sponsors/filters.html.haml", locals: {filters: Sponsor::DEFAULT_FILTERS}

    expect(rendered).to have_selector("form")
  end

  describe 'has form fields' do
    before :each do
      allow(Branch).to receive(:pluck).and_return(["branch1","branch2"])
      allow(Organization).to receive(:pluck).and_return(["organization1","organization2"])
      allow(Status).to receive(:pluck).and_return(["status1","status2"])
      allow(SponsorType).to receive(:pluck).and_return(["sponsor_type1","sponsor_type2"])
      allow(User).to receive(:pluck).and_return(["agent1","agent2"])
      allow(view).to receive(:country_options_for_select).and_return(["country1","country2"])
      allow(Sponsor).to receive_message_chain(:distinct, :pluck, :sort) {(["city1","city2"])}
    end

    specify "empty" do
      render partial: "hq/sponsors/filters.html.haml", locals: {filters: Sponsor::DEFAULT_FILTERS}

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
    end
    specify "filled" do
      render partial: "hq/sponsors/filters.html.haml", locals: {filters: sponsors_filters}

      #text fields
      expect(rendered).to have_selector("input[id='filters_name_value'][value='#{sponsors_filters["name"]["value"]}']")
      expect(rendered).to have_selector("input[id='filters_created_at_from'][value='#{sponsors_filters["created_at"]["from"]}']")
      expect(rendered).to have_selector("input[id='filters_created_at_until'][value='#{sponsors_filters["created_at"]["until"]}']")
      expect(rendered).to have_selector("input[id='filters_updated_at_from'][value='#{sponsors_filters["updated_at"]["from"]}']")
      expect(rendered).to have_selector("input[id='filters_start_date_from'][value='#{sponsors_filters["start_date"]["from"]}']")
      expect(rendered).to have_selector("input[id='filters_start_date_until'][value='#{sponsors_filters["start_date"]["until"]}']")
      expect(rendered).to have_selector("input[id='filters_active_sponsorship_count_value'][value='#{sponsors_filters["active_sponsorship_count"]["value"]}']")

      expect(rendered).to have_select("filters_name_option", selected: "Equals")
      expect(rendered).to have_select("filters_gender", selected: sponsors_filters["gender"])
      expect(rendered).to have_select("filters_branch", selected: sponsors_filters["branch"])
      expect(rendered).to have_select("filters_organization", selected: sponsors_filters["organization"])
      expect(rendered).to have_select("filters_status", selected: sponsors_filters["status"])
      expect(rendered).to have_select("filters_sponsor_type", selected: sponsors_filters["sponsor_type"])
      expect(rendered).to have_select("filters_agent", selected: sponsors_filters["agent"])
      expect(rendered).to have_select("filters_country", selected: sponsors_filters["country"])
      expect(rendered).to have_select("filters_city", selected: sponsors_filters["city"])
      expect(rendered).to have_select("filters_request_fulfilled", selected: "No")
      expect(rendered).to have_select("filters_active_sponsorship_count_option", selected: "Greather than")
    end
  end

  it "has submit buttons" do
    render partial: "hq/sponsors/filters.html.haml", locals: {filters: Sponsor::DEFAULT_FILTERS}

    expect(rendered).to have_selector("input[type='submit'][value='Filter']")
    expect(rendered).to have_selector("input[type='reset'][value='Clear Filters']")
  end
end