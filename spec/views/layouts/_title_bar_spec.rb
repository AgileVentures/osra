require 'rails_helper'

describe "layouts/_title_bar.html.erb", type: :view do
  before :each do
    assign(:action_item_links, [] )
    assign(:crumbs, [] )
  end

  describe 'breadcrumbs' do
    before :each do
      assign(:crumbs, [ 'Crumb1', RailsController.new.link_to('Crumb2', '/path/to/resource'), 'Crumb3' ] )
    end

    specify 'are visible' do
      render and expect(rendered).to match /class="breadcrumb"(.*)Crumb1(.+)Crumb2(.+)Crumb3/m
    end
  end

  describe 'action item links' do
    before :each do
      assign(:action_item_links, [ 'Lorem Ipsum', RailsController.new.link_to('Partners Index', admin_partners_path) ] )
    end

    specify 'are visible' do
      render
      expect(rendered).to match /class="action_items"(.*)Lorem Ipsum(.+)Partners Index/m
    end
  end
end
