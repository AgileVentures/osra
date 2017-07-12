require 'rails_helper'

RSpec.describe 'orphans/edit.html.erb', type: :view do
  before :each do
    assign :orphan, build_stubbed(:orphan_full)
    assign :partners, []
    assign :provinces, []
    assign :sponsorship_statuses, []
    assign :statuses, []
  end

  it 'renders the form partial' do
    render

    expect(view).to render_template(partial: '_form')
  end
end

