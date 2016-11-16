require 'rails_helper'
require 'will_paginate/array'

RSpec.describe 'sponsors/_sponsors.html.haml', type: :view do
  describe 'sponsors exist' do
    let(:sponsors) do
      [FactoryGirl.build_stubbed(:sponsor), FactoryGirl.build_stubbed(:sponsor)]
    end

    it 'should render something besides "No Sponsors found"' do
      render :partial => 'sponsors/sponsors.html.haml', :locals => {:sponsors => sponsors.paginate(page: 1), filters: {}}

      expect(rendered).to_not be_empty
      expect(rendered).to_not match /No Sponsors found/
    end

    it 'should link to #show actions' do
      render :partial => 'sponsors/sponsors.html.haml', :locals => {:sponsors => sponsors.paginate(page: 1), filters: {}}

      sponsors.each do |sponsor|
        expect(rendered).to match link_to(sponsor.name, sponsor_path(sponsor.id))
      end
    end

    it 'should have pagination buttons' do
      render :partial => 'sponsors/sponsors.html.haml', :locals => {:sponsors => sponsors.paginate(page: 1), filters: {}}

      expect(rendered).to have_selector('div.pagination')
    end

    it 'should have filters form' do
      render :partial => 'sponsors/sponsors.html.haml', :locals => {:sponsors => sponsors.paginate(page: 1), filters: {}}

      expect(response).to render_template(:partial => '_filters.html.haml')
    end

    it "should generate sorted links for table headers" do
      expect(view).to receive(:sortable_link).at_least(:once)
      render :partial => 'sponsors/sponsors.html.haml', :locals => {:sponsors => sponsors.paginate(page: 1), filters: {}}
    end
  end

  describe 'no sponsors exist' do
    before :each do
      render partial: 'sponsors/sponsors.html.haml', locals: {sponsors: [], filters: {}}
    end

    it 'should indicate no sponsors were found' do
      expect(rendered).to match /No Sponsors found/
    end

    it 'should not have pagination buttons' do
      expect(rendered).to_not have_selector('div.pagination')
    end

    it 'should have filters form' do
      expect(response).to render_template(:partial => '_filters.html.haml')
    end
  end

  describe 'required attributes:' do
    let(:sponsor) { FactoryGirl.build_stubbed(:sponsor) }

    before :each do
      render :partial => 'sponsors/sponsors.html.haml', :locals => {:sponsors => [sponsor].paginate(page: 1)}
    end

    %w[osra_num name status.name sponsor_type.name].each do |attrib|
      example "#{attrib}" do
        eval "expect(rendered).to match CGI::escape_html(sponsor.#{attrib}.to_s)"
      end
    end
  end

  describe 'request fulfilled' do
    let(:sponsor_one) { build_stubbed :sponsor, request_fulfilled: false,
                        active_sponsorship_count: 2, requested_orphan_count: 7 }
    let(:sponsor_two) { build_stubbed :sponsor, request_fulfilled: true,
                        active_sponsorship_count: 4, requested_orphan_count: 4 }

    it 'shows yes/no & numbers of active & requested sponsorships' do
      render :partial => 'sponsors/sponsors.html.haml',
        :locals => { :sponsors => [sponsor_one, sponsor_two].paginate(page: 1) }

      expect(rendered).to have_text 'No (2/7)'
      expect(rendered).to have_text 'Yes (4/4)'
    end
  end

end
