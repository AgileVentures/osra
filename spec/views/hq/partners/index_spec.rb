require 'rails_helper'

RSpec.describe "hq/partners/index.html.erb", type: :view do
  context 'partners exist' do
    it 'should not indicate no partners were found' do
      assign(:partners, [ FactoryGirl.create(:partner) ] )
      render and expect(rendered).to_not match /No Partners found/
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
      expect(rendered).to have_link('New Partner', new_hq_partner_path)
    end
  end
end

