require 'rails_helper'

RSpec.describe "shared/_sortable_table_header_link.html.erb", type: :view do

  before :each do
    allow(view).to receive(:params).and_return({"controller": "/hq/sponsors", "action": "index"})

    render :partial => 'shared/sortable_table_header_link.html.erb',
       :locals => {text: "Name", column: :name, :sort_by => {"column": "name", "direction": "asc"}}
  end

  it 'table headers should be links' do
    expect(rendered).to have_link "Name"
    expect(rendered).to_not have_selector "th[text='Name']"
  end

  it 'table headers should show glyphicon for selected field' do
    expect(rendered).to have_css "span.glyphicon"
  end
end
