require 'rails_helper'

RSpec.describe "partners/_form.html.erb", type: :view do
  let(:provinces) { Province.all }
  let(:statuses) { Status.all }
  let(:partner) { build_stubbed :partner,
                  region: "Region1", contact_details: "CD123"}

  before :each do
    assign(:provinces, provinces)
    assign(:statuses, statuses)
    assign(:partner, partner)
  end

  specify 'has a form' do
    render

    expect(rendered).to have_selector("form")
  end

  describe '"Cancel" button' do
    specify 'new partner record' do
      allow(partner).to receive(:id).and_return nil
      render

      expect(rendered).to have_link("Cancel", partners_path)
    end

    specify 'existing partner record' do
      allow(partner).to receive(:id).and_return 42
      render

      expect(rendered).to have_link("Cancel", partners_path(42))
    end
  end

  specify 'form values' do
    render

    expect(rendered).to have_field("Name", with: partner.name)
    expect(rendered).to have_field("Region", with: partner.region)
    expect(rendered).to have_field("Contact details", with: partner.contact_details)
    expect(rendered).to have_select("Province", selected: partner.province.name, with_options: provinces.pluck(:name), disabled: true)
    expect(rendered).to have_select("Status", selected: partner.status.name)
    expect(rendered).to have_field("Start date", with: partner.start_date.to_s)
    expect(rendered).to have_selector("input[type='submit'][value='Update Partner']")
  end

  describe 'required fields' do
    before(:each) { render }

    it 'marks required fields' do
      expect(rendered).to mark_required_fields_for Partner
    end

    it 'does not mark optional' do
      expect(rendered).not_to mark_optional_fields_for Partner
    end
  end
end
