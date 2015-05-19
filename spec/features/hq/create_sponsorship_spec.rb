require 'rails_helper'

RSpec.feature 'Create a sponsorship', :type => :feature do

  background do
    i_sign_in_as_admin
    a_sponsor_exists "First Sponsor"
    an_orphan_exists "First Orphan"
    an_orphan_exists "Second Orphan"
  end

  scenario 'Pairing a sponsor with orphans' do
    when_i_visit_show_sponsor "First Sponsor"
    then_i_should_be_on "hq_new_sponsorship_path", "First Sponsor"
    and_i_should_see "First Sponsor"
    and_i_should_see "First Orphan"
    and_i_should_see "Second Orphan"
    fill_orphan_with "sponsorship_start_date", "First Orphan", "2014-01-31"
    when_i_click "Sponsor this orphan", "First Orphan"
    then_i_should_be_on "hq_new_sponsorship_path", "First Sponsor"
    and_i_should_see "Return to Sponsor Page"
    and_i_should_see "No (1/2)"
    and_i_should_see "Sponsorship link was successfully created for First Orphan"
    fill_orphan_with "sponsorship_start_date", "Second Orphan", "2014-01-31"
    when_i_click "Sponsor this orphan", "Second Orphan"
    then_i_should_be_on "hq_sponsor_path", "First Sponsor"
    and_i_should_see_within "First Orphan", "Currently Sponsored Orphans"
    and_i_should_see_within "Second Orphan", "Currently Sponsored Orphans"

  end

  def a_sponsor_exists(sponsor_name)
    FactoryGirl.create :sponsor, name: sponsor_name, requested_orphan_count: 2
  end

  def an_orphan_exists(orphan_name)
    FactoryGirl.create :orphan, name: orphan_name
  end

  def visit_sponsor(sponsor_name)
    sponsor = Sponsor.find_by name: sponsor_name
    visit hq_sponsor_path sponsor.id
  end

  def then_i_should_be_on(page, sponsor_name)
    sponsor = Sponsor.find_by name: sponsor_name
    case page.to_sym
      when :hq_sponsor_path then expect(current_path).to eq hq_sponsor_path sponsor.id
      when :hq_new_sponsorship_path then expect(current_path).to eq hq_new_sponsorship_path sponsor.id
      else raise('path to specified is not listed in #path_to')
    end
  end

  def when_i_visit_show_sponsor(sponsor_name)
    visit_sponsor sponsor_name
    click_link 'Link to Orphan'
  end

  def fill_orphan_with(field, orphan_name, value)
    orphan = Orphan.find_by_name orphan_name
    tr_id = "#orphan_#{orphan.id}"
    within(tr_id) { fill_in field, with: value }
  end

  def when_i_click(link, orphan_name)
    orphan = Orphan.find_by_name orphan_name
    tr_id = "#orphan_#{orphan.id}"
    within(tr_id) { click_button link }
  end

  def and_i_should_see_within(orphan_name, panel)
    panel_id = "##{panel.parameterize('_')}"
    within(panel_id) { expect(page).to have_content orphan_name }
  end
end
