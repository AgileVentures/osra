require 'rails_helper'

RSpec.describe "hq/sponsors/_index.html.haml", type: :view do
  describe 'sponsors exist' do
    let(:sponsors) do
      [FactoryGirl.build_stubbed(:sponsor), FactoryGirl.build_stubbed(:sponsor)]
    end

    before :each do
      render :partial => 'hq/sponsors/index.html.haml', :locals => {:sponsors => sponsors}
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
  end

  describe 'no sponsors exist' do
    it 'should indicate no sponsors were found' do
      render partial: 'hq/sponsors/index.html.haml', locals: {sponsors: []}
      expect(rendered).to match /No Sponsors found/
    end
  end

  describe 'required attributes:' do
    let(:sponsor) { FactoryGirl.build_stubbed(:sponsor) }

    before :each do
      render :partial => 'hq/sponsors/index.html.haml', :locals => {:sponsors => [sponsor]}
    end

    %w[osra_num name status.name sponsor_type.name].each do |attrib|
      example "#{attrib}" do
        eval "expect(rendered).to match sponsor.#{attrib}.to_s"
      end
    end
  end
end
