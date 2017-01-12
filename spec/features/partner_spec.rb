require 'rails_helper'
require 'spec_helper'

=begin
Feature:
    As a site admin for osra
    So that I may maintain the information about osra partners
    I would like to be able to create, read and update partners in the admin section
=end
RSpec.feature 'Partner', :type => :feature do

  background do
    given_partners_exist [ { name: 'Partner1', region: 'Region1', status: 'Active', province: 'Damascus & Rif Dimashq', contact_details: 12345, start_date: '2013-09-25' },
                           { name: 'Partner2', region: 'Region2', status: 'Active', province: 'Aleppo',                 contact_details: 23456, start_date: '2013-09-25' },
                           { name: 'Partner3', region: 'Region3', status: 'Active', province: 'Homs',                   contact_details: 34567, start_date: '2013-09-25' } ]
    i_sign_in_as_admin
  end

  scenario  'There should be a list of partners on the admin index page' do
    visit partners_path
    and_i_should_see 'Partner1'
    and_i_should_see 'Partner2'
    and_i_should_see 'Partner3'
  end

  scenario 'I should see the generated osra numbers on the admin index page' do
    visit partners_path
    i_should_see_the_following_codes_for_partners [ { name: 'Partner1', expected_code: '11001' },
                                                    { name: 'Partner2', expected_code: '12001' },
                                                    { name: 'Partner3', expected_code: '13001' }]
  end

  scenario 'I should see the required fields on the index page' do
    visit partners_path
    i_should_see_the_following_fields_on_the_page [ { field: 'osra_num',   value: '11001' },
                                                    { field: 'name',       value: 'Partner1' },
                                                    { field: 'status',     value: 'Active' },
                                                    { field: 'province',   value: 'Damascus & Rif Dimashq' },
                                                    { field: 'start_date', value: '25 September 2013' } ]
  end

  scenario 'I should see the required fields on the partner show page' do
    given_i_am_on_page_for_partner 'Show Partner', 'Partner1'
    i_should_see_the_following_fields_on_the_page [ { field: 'osra_num',        value: '11001' },
                                                    { field: 'name',            value: 'Partner1' },
                                                    { field: 'status',          value: 'Active' },
                                                    { field: 'province',        value: 'Damascus & Rif Dimashq' },
                                                    { field: 'contact_details', value: '12345' },
                                                    { field: 'start_date',      value: '25 September 2013' } ]

  end

  scenario 'Should be able to visit a partner from the partner index page' do
    visit partners_path
    click_link 'Partner1'
    and_i_should_be_on :partner_page, { partner_name: 'Partner1' }

  end

  scenario 'Should be able to add a partner from the partner index page' do
    given_i_am_on_page_for_partner 'New Partner'
    fill_in 'Name', :with => 'Partner4'
    select 'Aleppo', :from => 'Province'
    fill_in 'Region', :with => 'Region1'
    click_button 'Create Partner'
    and_i_should_be_on :partner_page, { partner_name: 'Partner4' }
    and_i_should_see 'Partner successfuly saved'
    and_i_should_see 'Partner4'
  end

  scenario 'Should be able to edit a partner from the partner show page' do
    given_i_am_on_page_for_partner 'Show Partner', 'Partner1'
    click_link 'Edit Partner'
    and_i_should_be_on :edit_partner_page, { partner_name: 'Partner1' }
    fill_in 'Region', :with => 'New Region'
    click_button 'Update Partner'
    and_i_should_be_on :partner_page, { partner_name: 'Partner1' }
    and_i_should_see 'Partner successfuly saved'
    and_i_should_see 'New Region'
  end

  scenario 'Should not be able to edit a partner\'s province or osra_num' do
    given_i_am_on_page_for_partner 'Edit Partner', 'Partner1'
    i_should_not_be_able_to_change 'Province', 'partner'
  end

  scenario 'Should not be able to delete a partner from the partner show page' do
    given_i_am_on_page_for_partner 'Show Partner', 'Partner1'
    and_i_should_not_see 'Delete Partner'
  end

  scenario 'Should return to partner show page on cancelling edit partner' do
    given_i_am_on_page_for_partner 'Show Partner', 'Partner1'
    click_link 'Edit Partner'
    fill_in 'Region', :with => 'New Region'
    click_link 'Cancel'
    and_i_should_be_on :partner_page, { partner_name: 'Partner1' }
    and_i_should_not_see 'New Region'
  end

  def i_should_see_the_following_codes_for_partners table
    table.each do |hash|
      partner = Partner.find_by_name hash[:name]
      expect(partner.osra_num).to eq(hash[:expected_code])
      expect(page).to have_content(hash[:expected_code])
    end
  end

  def i_should_see_the_following_fields_on_the_page table
    table.each do |hash|
      expect(page).to have_content(hash[:value])
    end
  end

  def given_i_am_on_page_for_partner page_name, partner_name = nil
    if partner_name.nil?
      visit path_to_partner_role page_name
    else
      partner = Partner.find_by name: partner_name unless partner_name.nil?
      visit path_to_partner_role page_name, partner.id
    end
  end

  def path_to_partner_role page_name, id = nil
    name = page_name.downcase
    case name
      when 'edit partner' then
        edit_partner_path id
      when 'show partner' then
        partner_path id
      when 'new partner' then
        new_partner_path
    end
  end

  def i_should_not_be_able_to_change field, obj
    obj_to_param = obj.parameterize('_')
    obj_class = obj_to_param.classify.constantize
    associations = obj_class.reflect_on_all_associations.map{ |assoc| assoc.name.to_s }

    field_to_param = field.parameterize('_')
    css_selector = "##{obj_to_param}_#{field_to_param}"
    if associations.include? field_to_param
      css_selector = "#{css_selector}_id"
    end

    expect(find(css_selector)['readonly'] || find(css_selector)['disabled']).to be
  end
end
