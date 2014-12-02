require 'rails_helper'

describe "partners/new.html.erb", type: :view do
  let(:partner) do
    FactoryGirl.create(:partner)
  end

  context 'partner' do
    before :each do
      assign(:form_statuses, [{name: 'Status1', id: 1, selected: false},{name: 'Status2', id: 2, selected: true}])
      assign(:form_provinces, [{name: 'Province1', id: 1, selected: true},{name: 'Province2', id: 2, selected: false}])
      assign(:partner, partner)
    end

    it 'has just the create action button' do
      render and expect(rendered).to match /Create Partner/
      expect(rendered).to_not match /Update Partner/
    end

    it 'has a cancel button' do
      render and expect(rendered).to match /Cancel/
    end
  end

end
