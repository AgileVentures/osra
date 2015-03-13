require 'rails_helper'

RSpec.describe 'hq/orphans/edit.html.erb', type: :view do
  before :each do
    assign :orphan_statuses, OrphanStatus.all
    assign :orphan_sponsorship_statuses, OrphanSponsorshipStatus.all
    assign :provinces, Province.all
    assign :orphan, build_stubbed(:orphan)
  end

  it 'renders the form partial' do
    render

    expect(view).to render_template(partial: '_form')
  end
end

