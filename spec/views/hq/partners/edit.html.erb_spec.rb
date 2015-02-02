require 'rails_helper'

RSpec.describe 'hq/partners/edit.html.erb', type: :view do
  before :each do
    assign :facade, PartnerFacade.new(build_stubbed :partner)
  end

  it 'renders the form partial' do
    render

    expect(view).to render_template(partial: '_form')
  end

end

