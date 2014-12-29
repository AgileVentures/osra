require 'rails_helper'

describe "hq/partners/index.html.erb", type: :view do
  context 'partners exist' do
    let(:partners) do
      3.times do
        FactoryGirl.create :partner
      end
      Partner.all
    end

    before :each do
      assign(:partners, partners)
    end

    it 'should not indicate no partners were found' do
      render and expect(rendered).to_not match /No Partners found/
    end
  end

  context 'no partners exist' do
    before :each do
      assign(:partners, [])
    end

    it 'should indicate no partners were found' do
      render and expect(rendered).to match /No Partners found/
    end
  end

end

