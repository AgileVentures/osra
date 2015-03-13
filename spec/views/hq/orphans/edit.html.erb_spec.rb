require 'rails_helper'

RSpec.describe 'hq/orphans/edit.html.erb', type: :view do
  before :each do
    assign :orphan, build_stubbed(:orphan)
  end

  it 'renders the form partial' do
    render

    expect(view).to render_template(partial: '_form')
  end
end

