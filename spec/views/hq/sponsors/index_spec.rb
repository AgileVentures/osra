require 'rails_helper'

RSpec.describe "hq/sponsors/index.html.haml", type: :view do
  let(:sponsors) do
    [ FactoryGirl.build_stubbed(:sponsor), FactoryGirl.build_stubbed(:sponsor)]
  end

  describe 'sponsors exist' do
    before :each do
      assign(:sponsors, sponsors)
    end

    it 'should not indicate no sponsors were found' do
      render and expect(rendered).to_not match /No Sponsors found/
    end

    it 'should link to #show actions' do
      render
      sponsors.each do |sponsor|
        expect(rendered).to have_link(sponsor.name, hq_sponsor_path(sponsor.id))
      end
    end
  end

  describe 'no sponsors exist' do
    it 'should indicate no sponsors were found' do
      assign(:sponsors, [])
      render and expect(rendered).to match /No Sponsors found/
    end
  end

end
