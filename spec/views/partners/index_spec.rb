require 'rails_helper'

describe "partners/index.html.erb", type: :view do
  let(:partners) do
    67.times do
      FactoryGirl.create :partner, province: Province.find_by_name('Aleppo')
    end
    Partner.all
  end

  context 'partners' do
    before :each do
      assign(:partners, partners)
      assign(:request_params, {})
      assign(:model, Partner)
    end

    it 'should contain the number of partners' do
      render and expect(rendered).to have_text 'Displaying all 67 Partners'
    end


  end
  context 'no partners' do
    before :each do
      assign(:partners, [])
      assign(:request_params, {})
    end

    it 'should indicate no partners were found' do
      render and expect(rendered).to match /No Partners found/
    end
  end

end
