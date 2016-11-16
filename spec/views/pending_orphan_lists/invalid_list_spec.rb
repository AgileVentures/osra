require 'rails_helper'

RSpec.describe "pending_orphan_lists/invalid_list.html.erb", type: :view do
  let(:partner) { build_stubbed :partner }
  let(:result) do
    [ {ref: "location1", error: "error1"},
      {ref: "location2", error: "error2"},
      {ref: "location3", error: "error3"} ]
  end

  before :each do
    render template: "pending_orphan_lists/invalid_list.html.erb",
            locals: { partner: partner,
                      result: result }
  end

  it 'should delegate to partials' do
    expect(view).to render_template partial: "layouts/_content_title.erb"
  end

  it 'shows Spredsheet orphans table' do
      expect(rendered).to have_text(result.first[:ref])
      expect(rendered).to have_text(result.first[:error])
      expect(rendered).to have_selector('tbody tr', count: 3)
  end

  it 'shows cancle button' do
    expect(rendered).to have_link("Cancel", partner_path(partner))
  end
end
