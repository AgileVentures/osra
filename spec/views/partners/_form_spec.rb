require 'rails_helper'

describe "partners/_form.html.erb", type: :view do
  let :partner do
    FactoryGirl.create(:partner)
    Partner.first
  end

  context 'edit-form options' do
    before :each do
      assign(:form_statuses, [{name: 'Status1', id: 1, selected: false}, {name: 'Status2', id: 2, selected: true}])
      assign(:form_provinces, [{name: 'Province1', id: 1, selected: true}, {name: 'Province2', id: 2, selected: false}])
      assign(:partner, partner)
      assign(:edit, true)
    end

    context 'for new partner' do
      before :each do
        assign(:edit, false)
      end

      it 'shows a province selector' do
        render and expect(rendered).to have_select('partner_province_id', with_options: ['', 'Province1', 'Province2'])
      end

      it 'shows no osra_num field' do
        render and expect(rendered).to_not match /Osra num/
      end
    end

    describe 'osra_num field' do
      it 'is shown' do
        render and expect(rendered).to match /Osra num/
      end

      it 'is readonly' do
        render and expect(rendered).to match /name="partner\[osra_num\]" readonly="readonly"/
      end
    end

    it 'disables province selector' do
      render and expect(rendered).to_not have_select('partner_province_id', selected: 'Province2',
                                                      with_options: ['', 'Province1', 'Province2'])
    end

    it 'pre-selects a status' do
      render and expect(rendered).to have_select('partner_status_id', selected: 'Status2',
                                                  with_options: ['', 'Status1', 'Status2'])
    end
  end
end
