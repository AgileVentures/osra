require 'rails_helper'
require 'will_paginate/array'

RSpec.describe 'hq/sponsors/index.html.haml', type: :view do
  before :each do
    assign(:sponsors, [])
    assign(:filters, {})
    assign(:sort_by, {})
    assign(:sortable_by_column, true)
  end

  let(:sponsors_count) { build_stubbed_list(:sponsor, 5).count }
  let(:sponsors) do
    items = build_stubbed_list :sponsor, 5
    items.paginate(:page => 2, :per_page => 2)
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

  it 'should show total number of sponsors' do
    assign(:sponsors_count, sponsors_count)
    assign(:sponsors, sponsors)
    render
    expect(rendered).to have_content('Displaying ' + sponsors.count.to_s + ' of ' + sponsors_count.to_s + ' Sponsors.')
  end

  describe 'class action-items should have link' do
    specify 'New Sponsor' do
      render
      expect(rendered).to have_link('New Sponsor', new_hq_sponsor_path)
    end
  end
end
