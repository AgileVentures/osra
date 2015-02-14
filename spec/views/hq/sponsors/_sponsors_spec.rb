require 'rails_helper'
require 'cgi'

RSpec.describe 'hq/sponsors/_sponsors.html.haml', type: :view do
  describe 'sponsors exist' do
    let(:sponsors) do
      [FactoryGirl.build_stubbed(:sponsor), FactoryGirl.build_stubbed(:sponsor)]
    end

    before :each do
      render :partial => 'hq/sponsors/sponsors.html.haml', :locals => {:sponsors => sponsors.paginate(page: 1)}
    end

    it 'should render something besides "No Sponsors found"' do
      expect(rendered).to_not be_empty
      expect(rendered).to_not match /No Sponsors found/
    end

    it 'should link to #show actions' do
      sponsors.each do |sponsor|
        expect(rendered).to match link_to(sponsor.name, hq_sponsor_path(sponsor.id))
      end
    end

    it 'should have pagination buttons' do
      expect(rendered).to have_selector('div.pagination')
    end
  end

  describe 'no sponsors exist' do
    it 'should indicate no sponsors were found' do
      render partial: 'hq/sponsors/sponsors.html.haml', locals: {sponsors: []}
      expect(rendered).to match /No Sponsors found/
    end

    it 'should not have pagination buttons' do
      expect(rendered).to_not have_selector('div.pagination')
    end
  end

  describe 'required attributes:' do
    let(:sponsor) { FactoryGirl.build_stubbed(:sponsor) }

    before :each do
      render :partial => 'hq/sponsors/sponsors.html.haml', :locals => {:sponsors => [sponsor].paginate(page: 1)}
    end

    %w[osra_num name status.name sponsor_type.name].each do |attrib|
      example "#{attrib}" do
        eval "expect(rendered).to match CGI::escape_html(sponsor.#{attrib}.to_s)"
      end
    end
  end
end
