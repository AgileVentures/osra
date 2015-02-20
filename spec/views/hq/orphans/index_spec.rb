require 'rails_helper'
require 'will_paginate/array'

RSpec.describe "hq/orphans/index.html.erb", type: :view do
  context 'partners exist' do
    let(:orphans) do
      (1..5).each_with_object([]) do |num, arr|
        arr << FactoryGirl.build_stubbed(:orphan)
      end.paginate(:page => 2, :per_page => 2)
    end

    before :each do
      assign(:orphans, orphans)
    end

    it 'should not indicate no partners were found' do
      render and expect(rendered).to_not match /No Orphans found/
    end

    it "calls will_paginate gem " do
      allow(view).to receive(:will_paginate).and_return('success')
      render
      expect(rendered).to match /success/
    end
  end

  context 'no orphans exist' do
    it 'should indicate no orphans were found' do
      assign(:orphans, [])
      render and expect(rendered).to match /No Orphans found/
    end
  end
end
