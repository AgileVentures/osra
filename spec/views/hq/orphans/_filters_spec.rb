require 'rails_helper'

RSpec.describe "hq/orphans/filters.html.erb", type: :view do
  let(:orphans_filters) {build :orphan_filter, name_option: "equals",
                               father_given_name_option: "equals", family_name_option: "equals"}
  let(:orphans) {build_stubbed_list(:orphan,5)}

  it 'has a form' do
    render partial: "hq/orphans/filters.html.erb", locals: {filters: {}}

    expect(rendered).to have_selector("form")
  end

  describe 'has form fields' do

    specify "empty" do
      render partial: "hq/orphans/filters.html.erb", locals: {filters: {}}

      #text fields
      [:name_value, :father_given_name_value, :family_name_value,
       :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
       :date_of_birth_from, :date_of_birth_until].each do |field|
          expect(rendered).to have_selector("input[name='filters[#{field.to_s}]']")
          expect(rendered).to_not have_selector("input[name='filters[#{field.to_s}]'][value]")
      end

      #select fields
      [:name_option, :father_given_name_option, :family_name_option, :gender, :priority,
       :province_code, :sponsorship_status, :status, :father_is_martyr, :mother_alive,
       :goes_to_school, :health_status]. each do |field|
        expect(rendered).to have_selector("select[name='filters[#{field.to_s}]']")
        expect(rendered).to_not have_selector("select[name='filters[#{field.to_s}]'] option[selected]")
      end
    end

    specify "filled" do
      allow(Province).to receive_message_chain(:distinct, :pluck)
                             .with(:name, :code)
                             .and_return([["code1", "code2"],
                                          [orphans_filters[:province_code].to_s,
                                           orphans_filters[:province_code].to_s]])

      render partial: "hq/orphans/filters.html.erb", locals: {filters: orphans_filters}

      #text fields
      [:name_value, :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
       :date_of_birth_from, :date_of_birth_until].each do |field|
        expect(rendered).to have_selector("input[name='filters[#{field.to_s}]'][value='#{orphans_filters[field]}']") if orphans_filters[field]
      end

      #select fields
      expect(rendered).to have_select("filters[gender]", selected: orphans_filters[:gender])
      expect(rendered).to have_selector("filters[province_code]", text: orphans_filters[:province_code]) if not orphans_filters[:province_code].nil?
      expect(rendered).to have_select("filters[father_is_martyr]", selected: (orphans_filters[:father_is_martyr] ? "Yes" : "No"))
      expect(rendered).to have_select("filters[mother_alive]", selected: (orphans_filters[:mother_alive] ? "Yes" : "No"))
      expect(rendered).to have_select("filters[goes_to_school]", selected: (orphans_filters[:goes_to_school] ? "Yes" : "No")) if not orphans_filters[:goes_to_school].nil?
    end

    specify "priority" do
      allow(Orphan).to receive_message_chain(:distinct, :pluck, :sort, :map) {([])}
      allow(Orphan).to receive_message_chain(:distinct, :pluck, :map) {([])}
      allow(Orphan).to receive_message_chain(:distinct, :pluck).with(:priority).and_return(["priority1","priority2", orphans_filters[:priority].to_s])
      render partial: "hq/orphans/filters.html.erb", locals: {filters: orphans_filters}
      expect(rendered).to have_select("filters[priority]", selected: orphans_filters[:priority])
    end

    specify "health_status" do
      allow(Orphan).to receive_message_chain(:distinct, :pluck, :sort, :map) {([])}
      allow(Orphan).to receive_message_chain(:distinct, :pluck, :map) {([])}
      allow(Orphan).to receive_message_chain(:distinct, :pluck).with(:health_status).and_return(["health_status1","health_status2", orphans_filters[:health_status].to_s])
      render partial: "hq/orphans/filters.html.erb", locals: {filters: orphans_filters}
      expect(rendered).to have_selector("select[name='filters[health_status]'] option[value='#{orphans_filters[:health_status]}']")
    end

    specify "status" do
      allow(Orphan).to receive_message_chain(:distinct, :pluck, :sort, :map) {([])}
      allow(Orphan).to receive_message_chain(:distinct, :pluck, :map) {([])}
      allow(Orphan).to receive_message_chain(:statuses, :key, :humanize) {([])}
      allow(Orphan).to receive_message_chain(:distinct, :pluck).with(:status).and_return([orphans_filters[:status]])
      render partial: "hq/orphans/filters.html.erb", locals: {filters: orphans_filters}
      expect(rendered).to have_selector("select[name='filters[status]'] option[value='#{orphans_filters[:status]}']")
    end

    specify "sponsorship_status" do
      allow(Orphan).to receive_message_chain(:distinct, :pluck, :sort, :map) {([])}
      allow(Orphan).to receive_message_chain(:distinct, :pluck, :map) {([])}
      allow(Orphan).to receive_message_chain(:sponsorship_statuses, :key, :humanize) {([])}
      allow(Orphan).to receive_message_chain(:distinct, :pluck).with(:sponsorship_status).and_return([orphans_filters[:sponsorship_status]])
      render partial: "hq/orphans/filters.html.erb", locals: {filters: orphans_filters}
      expect(rendered).to have_selector("select[name='filters[sponsorship_status]'] option[value='#{orphans_filters[:sponsorship_status]}']")
    end

  end

  it "has submit buttons" do
    render partial: "hq/orphans/filters.html.erb", locals: {filters: {}}

    expect(rendered).to have_selector("input[type='submit'][value='Filter']")
    expect(rendered).to have_selector("input[type='submit'][value='Clear Filters']")
  end
end
