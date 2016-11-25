require 'rails_helper'

RSpec.describe "sponsors/filters.html.haml", type: :view do
  let(:sponsors_filters) {build :sponsor_filter, name_option: "equals", active_sponsorship_count_option: "greather_than"}

  it 'has a form' do
    render partial: "sponsors/filters.html.haml", locals: {filters: {}}

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
      render partial: "sponsors/filters.html.haml", locals: {filters: {}}

      #text fields
      [:name_value, :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
        :start_date_from, :start_date_until, :active_sponsorship_count_value].each do |field|
          expect(rendered).to have_selector("input[name='filters[#{field.to_s}]']")
          expect(rendered).to_not have_selector("input[name='filters[#{field.to_s}]'][value]")
      end

      #select fields
      [:name_option, :gender, :branch_id, :organization_id, :status_id, :sponsor_type_id, :agent_id, :country, :city, :request_fulfilled, :active_sponsorship_count_option]. each do |field|
        expect(rendered).to have_selector("select[name='filters[#{field.to_s}]']")
        expect(rendered).to_not have_selector("select[name='filters[#{field.to_s}]'] option[selected]")
      end
    end

    specify "filled" do
      render partial: "sponsors/filters.html.haml", locals: {filters: sponsors_filters}

      #text fields
      [:name_value, :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
        :start_date_from, :start_date_until, :active_sponsorship_count_value].each do |field|
        expect(rendered).to have_selector("input[name='filters[#{field.to_s}]'][value=\"#{sponsors_filters[field]}\"]") if sponsors_filters[field]
      end

      #select fields
      expect(rendered).to have_select("filters[gender]", selected: sponsors_filters[:gender])
      expect(rendered).to have_selector("select[name='filters[branch_id]'] option[value='#{sponsors_filters[:branch_id]}'][selected]") if sponsors_filters[:branch_id]
      expect(rendered).to have_selector("select[name='filters[organization_id]'] option[value='#{sponsors_filters[:organization_id]}'][selected]") if sponsors_filters[:organization_id]
      expect(rendered).to have_selector("select[name='filters[status_id]'] option[value='#{sponsors_filters[:status_id]}'][selected]")
      expect(rendered).to have_selector("select[name='filters[sponsor_type_id]'] option[value='#{sponsors_filters[:sponsor_type_id]}'][selected]")
      expect(rendered).to have_selector("select[name='filters[agent_id]'] option[value='#{sponsors_filters[:agent_id]}'][selected]")
      expect(rendered).to have_selector("select[name='filters[country]'] option[value=\"#{sponsors_filters[:country]}\"][selected]")
      expect(rendered).to have_select("filters[city]", selected: sponsors_filters[:city])
      expect(rendered).to have_select("filters[name_option]", selected: "Equals")
      expect(rendered).to have_select("filters[request_fulfilled]", selected: (sponsors_filters[:request_fulfilled] ? "Yes" : "No"))
      expect(rendered).to have_select("filters[active_sponsorship_count_option]", selected: "Greather than")
    end
  end

  it "has submit buttons" do
    render partial: "sponsors/filters.html.haml", locals: {filters: {}}

    expect(rendered).to have_selector("input[type='submit'][value='Filter']")
    expect(rendered).to have_selector("input[type='submit'][value='Clear Filters']")
  end
end
