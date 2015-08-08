require 'rails_helper'

RSpec.describe 'hq/users/_sponsors.html.haml', type: :view do
  describe 'sponsors exist' do
    let(:sponsors) do
      [FactoryGirl.build_stubbed(:sponsor), FactoryGirl.build_stubbed(:sponsor)]
    end

    it 'should render something besides "No Sponsors found"' do
      render :partial => 'hq/sponsors/sponsors.html.haml', :locals => {:sponsors => sponsors.paginate(page: 1), filters: {}}

      expect(rendered).to_not be_empty
      expect(rendered).to_not match /No Sponsors found/
    end
  end

  describe 'no sponsors exist' do
    before :each do
      render partial: 'hq/users/sponsors.html.haml', locals: {sponsors: [], filters: {}}
    end

    it 'should indicate no sponsors were found' do
      expect(rendered).to match /No Sponsors found/
    end
  end
end
