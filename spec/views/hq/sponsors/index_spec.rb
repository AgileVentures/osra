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

  it "should have link for export sponsors list as csv with default values" do
    assign(:filters, {})
    assign(:current_sort_column, "name")
    assign(:current_sort_direction, "asc")
    render and expect(rendered).to have_link('Export to csv',
                                             href: hq_sponsors_path(format: :csv, filters: {}, sort_column: "name", sort_direction: "asc"))
  end

  it "should add filters and params to the export to csv link" do
    assign(:filters,{"active_sponsorship_count_option"=>"equals", "active_sponsorship_count_value"=>"", "agent_id"=>"", "branch_id"=>"5", "city"=>"Wehnerburgh", "country"=>"", "created_at_from"=>"", "created_at_until"=>"", "gender"=>"Male", "name_option"=>"contains", "name_value"=>"", "organization_id"=>"", "request_fulfilled"=>"", "sponsor_type_id"=>"", "start_date_from"=>"", "start_date_until"=>"", "status_id"=>"", "updated_at_from"=>"", "updated_at_until"=>""})
    assign(:current_sort_column, "name")
    assign(:current_sort_direction, "desc")
    render and expect(rendered).to have_link('Export to csv',
                                             href: hq_sponsors_path(format: :csv, filters: {"active_sponsorship_count_option"=>"equals", "active_sponsorship_count_value"=>"", "agent_id"=>"", "branch_id"=>"5", "city"=>"Wehnerburgh", "country"=>"", "created_at_from"=>"", "created_at_until"=>"", "gender"=>"Male", "name_option"=>"contains", "name_value"=>"", "organization_id"=>"", "request_fulfilled"=>"", "sponsor_type_id"=>"", "start_date_from"=>"", "start_date_until"=>"", "status_id"=>"", "updated_at_from"=>"", "updated_at_until"=>""}, sort_column: "name", sort_direction: "desc"))
  end
end
