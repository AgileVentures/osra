require 'rails_helper'

RSpec.describe 'hq/sponsors/edit.html.haml', type: :view do
  before :each do
    assign :sponsor, build_stubbed(:sponsor)
    assign :statuses, []
    assign :sponsor_types, []
    assign :organizations, []
    assign :branches, []
    assign :cities, []
  end

  it 'renders the form partial' do
    render

    expect(view).to render_template(partial: '_form')
  end

end
