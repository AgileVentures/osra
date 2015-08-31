require 'rails_helper'
require 'spec_helper'

=begin
Feature:
    As a site admin for osra
    So that I may maintain the information about osra sponsors
    I can create, read and update sponsors in the admin section
=end
RSpec.feature 'CRUD Sponsor', :type => :feature do

  background do
    @sponsors = create_list :sponsor_full, 3
    i_sign_in_as_admin
  end

  scenario 'I should see the required fields on the index page' do
    visit hq_sponsors_path
    @sponsors.each do |sponsor|
      i_should_see_the_following_fields_on_the_page [
        { field: 'osra_num',          value: sponsor.osra_num },
        { field: 'name',              value: sponsor.name },
        { field: 'status',            value: sponsor.status.name },
        { field: 'start_date',        value: format_date(sponsor.start_date) },
        { field: 'request_fulfilled', value: request_fulfilled_text(sponsor) },
        { field: 'sponsor_type',      value: sponsor.sponsor_type.name },
        { field: 'country',           value: en_ar_country(sponsor.country) }
      ]
    end
  end

  scenario 'I should see the required fields on the sponsor show page' do
    sponsor = @sponsors.first
    given_i_am_on_page_for_sponsor 'Show Sponsor', sponsor.name
    i_should_see_the_following_fields_on_the_page [
      { field: 'name',                   value: sponsor.name },
      { field: 'osra_num',               value: sponsor.osra_num },
      { field: 'status',                 value: sponsor.status.name },
      { field: 'gender',                 value: sponsor.gender },
      { field: 'start_date',             value: format_date(sponsor.start_date) },
      { field: 'requested_orphan_count', value: sponsor.requested_orphan_count },
      { field: 'request_fulfilled',      value: bool_to_s(sponsor.request_fulfilled) },
      { field: 'payment_plan',           value: sponsor.payment_plan },
      { field: 'sponsor_type',           value: sponsor.sponsor_type.name },
      { field: 'affiliate',              value: sponsor.affiliate },
      { field: 'country',                value: en_ar_country(sponsor.country) },
      { field: 'city',                   value: sponsor.city },
      { field: 'address',                value: sponsor.address },
      { field: 'email',                  value: sponsor.email },
      { field: 'contact1',               value: sponsor.contact1 },
      { field: 'contact2',               value: sponsor.contact2 },
      { field: 'additiona_info',         value: sponsor.additional_info },
      { field: 'agent',                  value: sponsor.agent.user_name },
      { field: 'created_at',             value: format_date(sponsor.created_at) },
      { field: 'updated_at',             value: format_date(sponsor.updated_at) }
    ]
  end

  scenario 'Should be able to visit a sponsor from the sponsor index page' do
    sponsor = @sponsors.first
    visit hq_sponsors_path
    click_link sponsor.name
    and_i_should_be_on :hq_sponsor_path, { sponsor_name: sponsor.name }
  end

  scenario 'Should be able to add a sponsor from the sponsor index page' do
    given_i_am_on_page_for_sponsor 'New Sponsor'
    fill_in 'Name', :with => 'Sponsor1'
    select 'Active', :from => 'Status'
    select 'Male', :from => 'Gender'
    fill_in 'Start date', :with => '2014-08-25'
    fill_in 'Requested orphan count', :with => '2'
    select 'Individual', :from => 'sponsor_sponsor_type_id'
    select Branch.all.first.name, :from => 'sponsor_branch_id'
    select '(Afghanistan) أفغانستان', :from => 'Country'
    select Sponsor.all_cities.first, :from => 'City'
    select @sponsors.first.agent.user_name, :from => 'sponsor_agent_id'
    click_button 'Create Sponsor'
    and_i_should_be_on :hq_sponsor_path, { sponsor_name: 'Sponsor1' }
    and_i_should_see 'Sponsor successfuly saved'
    and_i_should_see 'Sponsor1'
  end

  scenario 'Should be able to edit a sponsor from the sponsor show page' do
    name = @sponsors.first.name
    given_i_am_on_page_for_sponsor 'Show Sponsor', name
    click_link 'Edit Sponsor'
    and_i_should_be_on :edit_hq_sponsor_path, { sponsor_name: name }
    fill_in 'Additional info', :with => 'Additional Information'
    click_button 'Update Sponsor'
    and_i_should_be_on :hq_sponsor_path, { sponsor_name: name }
    and_i_should_see 'Sponsor successfuly saved'
    and_i_should_see 'Additional Information'
  end

  scenario "can't edit sponsor_type, organization or branch" do
    given_i_am_on_page_for_sponsor 'Edit Sponsor', @sponsors.first.name
    i_should_not_be_able_to_change 'Sponsor type', 'sponsor'
    i_should_not_be_able_to_change 'Organization', 'sponsor'
    i_should_not_be_able_to_change 'Branch', 'sponsor'
  end

  scenario "can't delete a sponsor from the sponsor show page" do
    given_i_am_on_page_for_sponsor 'Show Sponsor', @sponsors.first.name
    and_i_should_not_see 'Delete Sponsor'
  end

  scenario "returns to sponsor show page on cancelling edit sponsor" do
    name = @sponsors.first.name
    given_i_am_on_page_for_sponsor 'Show Sponsor', name
    click_link 'Edit Sponsor'
    fill_in 'Additional info', :with => 'Additional Information'
    click_link 'Cancel'
    and_i_should_be_on :hq_sponsor_path, { sponsor_name: name }
    and_i_should_not_see 'Additional Information'
  end

  private

  def i_should_see_the_following_fields_on_the_page table
    table.each do |hash|
      expect(page).to have_content(hash[:value])
    end
  end

  def given_i_am_on_page_for_sponsor page_name, sponsor_name = nil
    if sponsor_name.nil?
      visit path_to_sponsor_role page_name
    else
      sponsor = Sponsor.find_by name: sponsor_name unless sponsor_name.nil?
      visit path_to_sponsor_role page_name, sponsor.id
    end
  end

  def path_to_sponsor_role page_name, id = nil
    name = page_name.downcase
    case name
      when 'edit sponsor' then
        edit_hq_sponsor_path id
      when 'show sponsor' then
        hq_sponsor_path id
      when 'new sponsor' then
        new_hq_sponsor_path
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

  def format_date date
    date.strftime('%d %B %Y')
  end

  def bool_to_s bool
    bool ? "Yes" : "No"
  end

  def request_fulfilled_text sponsor
    status = bool_to_s sponsor.request_fulfilled
    count = sponsor.active_sponsorship_count
    total = sponsor.requested_orphan_count
    "#{status} (#{count}/#{total})"
  end

end
