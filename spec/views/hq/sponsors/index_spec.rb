require 'rails_helper'

RSpec.describe 'hq/sponsors/index.html.haml', type: :view do
  before :each do
    assign(:sponsors, [])
    assign(:filters, {})
    assign(:sort_by, {})
    assign(:sortable_by_column, true)
  end
  it 'should delegate to partial' do
    render

    expect(view).to render_template partial: 'hq/sponsors/sponsors.html.haml',
                                    locals: {sponsors: [], filters: {}, sort_by: {}, sortable_by_column: true}
  end

  it 'shows active & requested sponsorship totals' do
    allow(view).to receive(:total_active_sponsorships).
      and_return 3
    allow(view).to receive(:total_requested_sponsorships).
      and_return 10

    render

    expect(rendered).to have_text 'Currently sponsoring 3 orphans out of 10 requested.'
  end

  describe 'class action-items should have link' do
    specify 'New Sponsor' do
      render
      expect(rendered).to have_link('New Sponsor', new_hq_sponsor_path)
    end
  end

  it "should have link for export sponsors list as csv" do
    render and expect(rendered).to have_link('Export to csv',
                                             href: hq_sponsors_path(format: :csv, filters: {}, sort_column: {}, sort_direction: {}))
  end
end
