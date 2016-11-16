require 'rails_helper'

RSpec.describe "orphans/filters.html.erb", type: :view do
  let(:orphans_filters) {build :orphan_filter}

  it 'has a form' do
    render partial: "orphans/filters.html.erb", locals: {filters: {}}

    expect(rendered).to have_selector("form")
  end

  describe 'has form fields' do
    before :each do
      allow(Orphan).to receive_message_chain(:distinct, :pluck).with(:health_status)
                            .and_return(["health_status1", "health_status2", orphans_filters[:health_status].to_s])
      allow(Province).to receive_message_chain(:distinct, :pluck).with(:name, :code)
                            .and_return([["province1", "1"],["Selected Province", orphans_filters[:province_code].to_s]])
      allow(Orphan).to receive_message_chain(:distinct, :pluck).with(:priority)
                            .and_return(["priority1","priority2", orphans_filters[:priority].to_s])
      allow(Orphan).to receive_message_chain(:distinct, :pluck).with(:city)
                            .and_return(["city1","city2", orphans_filters[:original_address_city].to_s])
      allow(Orphan).to receive_message_chain(:distinct, :pluck).with(:sponsorship_status)
                            .and_return( (0..(Orphan.sponsorship_statuses.size-1)).to_a )
      allow(Orphan).to receive_message_chain(:distinct, :pluck).with(:status)
                            .and_return( (0..(Orphan.statuses.size-1)).to_a )
      allow(Partner).to receive_message_chain(:all_names).and_return(["partner1", "partner2", orphans_filters[:orphan_list_partner_name]])
    end

    specify "empty" do
      render partial: "orphans/filters.html.erb", locals: {filters: {}}

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
      render partial: "orphans/filters.html.erb", locals: {filters: orphans_filters}

      #text fields
      [:name_value, :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
       :date_of_birth_from, :date_of_birth_until].each do |field|
        expect(rendered).to have_selector("input[name='filters[#{field.to_s}]'][value=\"#{orphans_filters[field]}\"]") if orphans_filters[field]
      end

      #select fields
      expect(rendered).to have_select("filters[gender]", selected: orphans_filters[:gender])
      expect(rendered).to have_select("filters[province_code]", selected: "Selected Province") if not orphans_filters[:province_code].nil?
      expect(rendered).to have_select("filters[father_is_martyr]", selected: (orphans_filters[:father_is_martyr] ? "Yes" : "No"))
      expect(rendered).to have_select("filters[mother_alive]", selected: (orphans_filters[:mother_alive] ? "Yes" : "No"))
      expect(rendered).to have_select("filters[goes_to_school]", selected: (orphans_filters[:goes_to_school] ? "Yes" : "No")) if not orphans_filters[:goes_to_school].nil?
      expect(rendered).to have_select("filters[priority]", selected: orphans_filters[:priority])
      expect(rendered).to have_selector("select[name='filters[health_status]'] option[value='#{orphans_filters[:health_status]}']")
      expect(rendered).to have_selector("select[name='filters[status]'] option[value='#{orphans_filters[:status]}']")
      expect(rendered).to have_selector("select[name='filters[sponsorship_status]'] option[value='#{orphans_filters[:sponsorship_status]}']")
    end
  end

  it "has submit buttons" do
    render partial: "orphans/filters.html.erb", locals: {filters: {}}

    expect(rendered).to have_selector("input[type='submit'][value='Filter']")
    expect(rendered).to have_selector("input[type='submit'][value='Clear Filters']")
  end
end
