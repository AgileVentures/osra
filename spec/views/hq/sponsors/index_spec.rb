require 'rails_helper'

RSpec.describe "hq/sponsors/index.html.erb", type: :view do
  context 'sponsors exist' do
    it 'should not indicate no sponsors were found' do
      assign(:sponsors, [ FactoryGirl.build_stubbed(:sponsor) ] )
      render and expect(rendered).to_not match /No Sponsors found/
    end
  end

  context 'no sponsors exist' do
    it 'should indicate no sponsors were found' do
      assign(:sponsors, [])
      render and expect(rendered).to match /No Sponsors found/
    end
  end

end
