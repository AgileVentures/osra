require 'rails_helper'

RSpec.describe 'partners/new.html.erb', type: :view do
  before :each do
    assign :partner, Partner.new
    assign :statuses, Status.all
    assign :provinces, Province.all
  end

  it 'renders the form partial' do
    render

    expect(view).to render_template(partial: '_form')
  end

end
