require 'rails_helper'
require 'will_paginate/array'

RSpec.describe "partners/index.html.erb", type: :view do
  context 'partners exist' do
    let(:partners) do
      (1..5).each_with_object([]) do |num, arr|
        arr << FactoryGirl.build_stubbed(:partner)
      end.paginate(:page => 2, :per_page => 2)
    end

    before :each do
      assign(:partners, partners)
    end

    it 'should not indicate no partners were found' do
      render and expect(rendered).to_not match /No Partners found/
    end

    it "calls will_paginate gem " do
      allow(view).to receive(:will_paginate).and_return('success')
      render
      expect(rendered).to match /success/
    end

    it "should generate sorted links for table headers" do
      expect(view).to receive(:sortable_link).at_least(:once)

      render
    end
  end

  context 'no partners exist' do
    it 'should indicate no partners were found' do
      assign(:partners, [])
      render and expect(rendered).to match /No Partners found/
    end
  end

  describe 'class action-items' do
    specify 'New Partner' do
      assign(:partners, [])
      render
      expect(rendered).to have_link('New Partner', new_partner_path)
    end
  end
end

