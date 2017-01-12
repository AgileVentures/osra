require 'rails_helper'

RSpec.describe 'users/_sponsors.html.haml', type: :view do
  describe 'sponsors exist' do
    let(:sponsors) do
      [FactoryGirl.build_stubbed(:sponsor), FactoryGirl.build_stubbed(:sponsor)]
    end

    it 'should render something besides "No Sponsors found"' do
      allow(view).to receive(:will_paginate)

      render :partial => 'sponsors/sponsors.html.haml', :locals => {:sponsors => build_stubbed_list(:sponsor, 2), param_name: ''}

      expect(rendered).to_not be_empty
      expect(rendered).to_not match /No Sponsors found/
      expect(view).to have_received(:will_paginate)
    end
  end

  describe 'no sponsors exist' do

    it 'should indicate no sponsors were found' do
      allow(view).to receive(:will_paginate)

      render partial: 'users/sponsors.html.haml', locals: {sponsors: Sponsor.none, param_name: ''}

      expect(rendered).to match /No Sponsors found/
      expect(view).to have_received(:will_paginate)
    end
  end
end
