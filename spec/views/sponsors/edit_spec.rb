require 'rails_helper'

RSpec.describe 'sponsors/edit.html.haml', type: :view do
  before :each do
    assign :sponsor, build_stubbed(:sponsor)
    assign :statuses, []
    assign :sponsor_types, []
    assign :organizations, []
    assign :branches, []
    assign :cities, []

    render
  end

  it 'renders the form partial' do
    expect(view).to render_template(partial: '_form')
  end

  it 'does not render the Create and Add Another button' do
    expect(rendered).not_to have_button 'Create and Add Another'
  end
end
