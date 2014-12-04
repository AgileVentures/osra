require 'rails_helper'

describe "partners/show.html.erb", type: :view do
  let(:partner) do
    FactoryGirl.create(:partner)
  end
  context '@partner exists' do
    before :each do
      assign(:partner, partner)
    end

    context 'with orphan lists' do
      before :each do
        assign(:list, true)
      end

      it 'shows an orphan lists link' do
        render and expect(rendered).to match /All orphan lists/
      end
    end

    context 'without orphan lists' do
      before :each do
        assign(:list, false)
      end

      it 'shows no orphan lists link' do
        render and expect(rendered).to_not match /All orphan lists/
      end
    end
  end

end
