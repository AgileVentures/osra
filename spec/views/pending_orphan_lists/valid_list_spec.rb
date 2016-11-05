require 'rails_helper'

RSpec.describe "pending_orphan_lists/valid_list.html.erb", type: :view do
  let(:partner) { build_stubbed :partner }
  let(:pending_orphan_list) { instance_double PendingOrphanList, spreadsheet: 'sheet', destroy!: true }
  let(:orphan_list) { double }
  let(:pending_orphans) { build_stubbed_list :orphan, 3 }

  before :each do
    allow(pending_orphan_list).to receive(:id).and_return(1)

    render template: "pending_orphan_lists/valid_list.html.erb",
            locals: { partner: partner,
                      orphan_list: partner.orphan_lists.build,
                      pending_orphan_list: pending_orphan_list,
                      result: pending_orphans }
  end

  it 'should delegate to partials' do
    expect(view).to render_template partial: "layouts/_content_title.erb"
  end

  it 'shows Spredsheet orphans table' do
      expect(rendered).to have_text(pending_orphans.first.name)
      expect(rendered).to have_selector('tbody tr', count: 3)
  end

  it 'shows import form' do
    expect(rendered).to have_selector("input[type='hidden'][value='1']")
    expect(rendered).to have_selector("input[type='submit'][value='Import']")
    expect(rendered).to have_link("Cancel", partner_path(partner))
  end
end
