require 'rails_helper'

RSpec.describe "hq/pending_orphan_lists/upload.html.erb", type: :view do
  let(:partner) { FactoryGirl.build_stubbed :partner }

  before :each do
    assign :partner, partner
  end

  it 'should delegate to partials' do
    render

    expect(view).to render_template partial: 'layouts/_content_title.erb'
    expect(view).to render_template partial: 'shared/_errors'
  end

  it 'shows Spredsheet upload form' do
    render

    expect(rendered).to have_selector("input[type='file']")
    expect(rendered).to have_selector("input[type='submit'][value='Upload']")
    expect(rendered).to have_link("Cancel", hq_partner_path(partner))
  end

end
