require 'rails_helper'
require 'will_paginate/array'

RSpec.describe "orphans/index.html.erb", type: :view do

  describe 'orphans exist' do
    let(:sponsor) { build_stubbed(:sponsor) }
    let(:orphans_count) { build_stubbed_list(:orphan, 5).count }
    let(:orphans_sort_by_eligibility_count) { Orphan.sort_by_eligibility.count }
    let(:eligible_for_sponsorship ) { true }
    let(:orphans) do
      items = attributes_for_list :orphan, 5
      extra_attrs = {
        partner_name: "Partner",
        province_name: "Province",
        sponsor_id: 1,
        sponsor_name: "Sponsor",
        sponsor_osra_num: 1,
        status: "Active",
        sponsorship_status: "Unsponsored",
        age_in_years: 15
      }
      items.map! { |item| item.merge(extra_attrs) }
      items.map! { |item| OpenStruct.new(item) }
      items.paginate(:page => 2, :per_page => 2)
    end

    before :each do
      assign(:orphans, orphans)
      assign(:filters, {})
    end

    it 'should not indicate no orphans were found' do
      render and expect(rendered).to_not match /No Orphans found/
    end

    it "calls will_paginate gem " do
      allow(view).to receive(:will_paginate).and_return('success')
      render
      expect(rendered).to match /success/
    end

    it 'should show total number of orphans' do
      assign(:orphans_count, orphans_count)
      render
      expect(rendered).to have_content('Displaying ' + orphans.count.to_s + ' of ' + orphans_count.to_s + ' Orphans.')
    end

    context 'sponsors exists' do
      before :each do
        assign(:sponsor, sponsor)
      end

      it 'should show all orphans for scope all' do
        assign(:orphans_count, orphans_count)
        render
        expect(rendered).to have_link('All (' + orphans_count.to_s + ')',
                                      new_sponsorship_path(sponsor_id: sponsor.id, scope: :all))
      end

      it 'should show filter orphans for scope eligible for sponsorship' do
        assign(:orphans_sort_by_eligibility_count, orphans_sort_by_eligibility_count)
        assign(:eligible_for_sponsorship, eligible_for_sponsorship)
        render
        expect(rendered).to have_link('Eligible For Sponsorship (' + orphans_sort_by_eligibility_count.to_s + ')',
                                      new_sponsorship_path(sponsor_id: sponsor.id, scope: :eligible_for_sponsorship))
        expect(rendered).to have_content('Beginning')
      end
    end

    context 'sponsors not exists' do
      it 'should show all orphans for scope all' do
        assign(:orphans_count, orphans_count)
        render
        expect(rendered).to have_link('All (' + orphans_count.to_s + ')',
                                      orphans_path(sponsor_id: sponsor.id, scope: :all))
      end

      it 'should show filter orphans for scope eligible for sponsorship' do
        assign(:orphans_sort_by_eligibility_count, orphans_sort_by_eligibility_count)
        render
        expect(rendered).to have_link('Eligible For Sponsorship (' + orphans_sort_by_eligibility_count.to_s + ')',
                                      orphans_path(sponsor_id: sponsor.id, scope: :eligible_for_sponsorship))
      end
    end

    it 'should have filters form' do
      render and expect(response).to render_template(:partial => '_filters.html.erb')
    end

    it "should generate sorted links for table headers" do
      expect(view).to receive(:sortable_link).at_least(:once)

      render
    end

    it "should show link for export orphans list as csv with default values" do
      assign(:filters, {})
      assign(:current_sort_column, "orphans.name")
      assign(:current_sort_direction, "asc")
      render and expect(rendered).to have_link('Export to csv',
                                    href: orphans_path(format: :csv, sort_column: "orphans.name", sort_direction: "asc"))
    end

    it "should add filters and params to the export to csv link" do
      assign(:filters, {"created_at_from"=>"", "created_at_until"=>"", "date_of_birth_from"=>"", "date_of_birth_until"=>"", "family_name_option"=>"contains", "family_name_value"=>"", "father_given_name_option"=>"contains", "father_given_name_value"=>"", "father_is_martyr"=>"", "gender"=>"Female", "goes_to_school"=>"", "health_status"=>"", "mother_alive"=>"true", "name_option"=>"contains", "name_value"=>"", "original_address_city"=>"", "orphan_list_partner_name"=>"", "priority"=>"", "province_code"=>"", "sponsorship_status"=>"", "status"=>"", "updated_at_from"=>"", "updated_at_until"=>""})
      assign(:current_sort_column, "orphans.name")
      assign(:current_sort_direction, "desc")
      render and expect(rendered).to have_link('Export to csv',
                                    href: orphans_path(format: :csv, filters: {"created_at_from"=>"", "created_at_until"=>"", "date_of_birth_from"=>"", "date_of_birth_until"=>"", "family_name_option"=>"contains", "family_name_value"=>"", "father_given_name_option"=>"contains", "father_given_name_value"=>"", "father_is_martyr"=>"", "gender"=>"Female", "goes_to_school"=>"", "health_status"=>"", "mother_alive"=>"true", "name_option"=>"contains", "name_value"=>"", "original_address_city"=>"", "orphan_list_partner_name"=>"", "priority"=>"", "province_code"=>"", "sponsorship_status"=>"", "status"=>"", "updated_at_from"=>"", "updated_at_until"=>""}, sort_column: "orphans.name", sort_direction: "desc"))
    end
  end

  context 'no orphans exist' do
    before :each do
      assign(:orphans, [])
      assign(:filters, {})
    end

    it 'should indicate no orphans were found' do
      render and expect(rendered).to match /No Orphans found/
    end

    it 'should have filters form' do
      render and expect(response).to render_template(:partial => '_filters.html.erb')
    end
  end
end
