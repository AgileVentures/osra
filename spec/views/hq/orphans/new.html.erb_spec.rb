require 'rails_helper'

RSpec.describe 'hq/orphans/new.html.erb', type: :view do
  before :each do
    assign :orphan, Orphan.new
  end

  it 'renders the form partial' do
    render

    expect(view).to render_template(partial: '_form')
  end
end
