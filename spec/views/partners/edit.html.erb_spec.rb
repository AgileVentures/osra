require 'rails_helper'

RSpec.describe 'partners/edit.html.erb', type: :view do
  before :each do
    assign :partner, build_stubbed(:partner)
    assign :statuses, Status.all
    assign :provinces, Province.all
  end

  it 'renders the form partial' do
    render

    expect(view).to render_template(partial: '_form')
  end

end

