require 'rails_helper'

RSpec.describe 'orphans/edit.html.erb', type: :view do
  before :each do
    assign :statuses, []
    assign :sponsorship_statuses, []
    assign :provinces, []
    assign :orphan, build_stubbed(:orphan_full)
  end

  it 'renders the form partial' do
    render

    expect(view).to render_template(partial: '_form')
  end
end

