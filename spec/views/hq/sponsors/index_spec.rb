require 'rails_helper'

RSpec.describe 'hq/sponsors/index.html.haml', type: :view do
  it 'should delegate to partial' do
    assign(:sponsors, [])
    render

    expect(view).to render_template partial: 'hq/sponsors/sponsors.html.haml', locals: {sponsors: []}
  end

  it 'shows active & requested sponsorship totals' do
    assign(:sponsors, [])
    allow(view).to receive(:total_active_sponsorships).
      and_return 3
    allow(view).to receive(:total_requested_sponsorships).
      and_return 10

    render

    expect(rendered).
      to have_text 'Currently sponsoring 3 orphans out of 10 requested.'
  end

  describe 'class action-items should have link' do
    specify 'New Sponsor' do
      assign(:sponsors, [])
      render
      expect(rendered).to have_link('New Sponsor', new_hq_sponsor_path)
    end
  end
end
