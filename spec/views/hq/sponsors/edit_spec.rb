require 'rails_helper'

RSpec.describe 'hq/sponsors/edit.html.haml', type: :view do
  before :each do
    assign :sponsor, build_stubbed(:sponsor)
    assign :statuses, Status.all
    assign :sponsor_types, SponsorType.all
    assign :organizations, Organization.all
    assign :branches, Branch.all
    assign :cities, Sponsor.all_cities.unshift(Sponsor::NEW_CITY_MENU_OPTION)
  end

  it 'renders the form partial' do
    render

    expect(view).to render_template(partial: '_form')
  end

end
