require 'rails_helper'

RSpec.feature 'Sponsorship Features', :type => :feature do

  background do
    i_sign_in_as_admin
    a_sponsor_exists "First Sponsor"
    an_orphan_exists "First Orphan"
    an_orphan_exists "Second Orphan"
  end

  scenario 'Pairing a sponsor with orphans' do
    when_i_visit_show_sponsor "First Sponsor"
    and_i_should_be_on "hq_new_sponsorship_page", {sponsor_name: "First Sponsor"}
    and_i_should_see "First Sponsor"
    and_i_should_see "First Orphan"
    and_i_should_see "Second Orphan"
    fill_orphan_with "sponsorship_start_date", "First Orphan", "2014-01-01"
    when_i_click "Sponsor this orphan", "First Orphan"
    and_i_should_be_on "hq_new_sponsorship_page", {sponsor_name: "First Sponsor"}
    and_i_should_see "Return to Sponsor Page"
    and_i_should_see "No (1/2)"
    and_i_should_see "Sponsorship link was successfully created for First Orphan"
    fill_orphan_with "sponsorship_start_date", "Second Orphan", "1900-02-01"
    when_i_click "Sponsor this orphan", "Second Orphan"
    and_i_should_see "Validation failed"
    fill_orphan_with "sponsorship_start_date", "Second Orphan", "2014-02-01"
    when_i_click "Sponsor this orphan", "Second Orphan"
    and_i_should_be_on "hq_sponsor_page", {sponsor_name: "First Sponsor"}
    and_i_should_see_within "Currently Sponsored Orphans", "First Orphan"
    and_i_should_see "2014-01-01"
    and_i_should_see_within "Currently Sponsored Orphans", "Second Orphan"
    and_i_should_see "Sponsorship link was successfully created."
  end

  scenario 'Sponsor on hold cannot create sponsorships' do
    given_sponsor_on_hold "Second Sponsor"
    visit_sponsor "Second Sponsor"
    and_i_should_not_see "First Orphan"
    and_i_should_not_see "Second Orphan"
  end

  scenario 'Inactive sponsor cannot create sponsorships' do
    given_inactive_sponsor "Second Sponsor"
    visit_sponsor "Second Sponsor"
    and_i_should_not_see "First Orphan"
    and_i_should_not_see "Second Orphan"
  end

  scenario 'End sponsorship' do
    sponsor = Sponsor.first
    orphan = Orphan.first
    given_sponsor_sponsors_orphan sponsor, orphan
    visit hq_sponsor_path sponsor.id
    i_should_see_one_active_sponsorship orphan
    click_button 'End Sponsorship'
    and_i_should_be_on "hq_sponsor_page", {sponsor_name: sponsor.name}
    and_i_should_see "Sponsorship Ended"
    i_should_see_one_inactive_sponsorship orphan
    visit hq_orphan_path orphan.id
    i_should_see_previously_sponsored
  end

  scenario 'Delete sponsorship' do
    sponsor = Sponsor.first
    orphan = Orphan.first
    given_sponsor_sponsors_orphan sponsor, orphan
    visit hq_sponsor_path sponsor.id
    i_should_see_one_active_sponsorship orphan
    click_link 'X'
    and_i_should_be_on "hq_sponsor_page", {sponsor_name: sponsor.name}
    and_i_should_see "Sponsorship record was successfully destroyed"
    i_should_see_no_sponsorships
    visit hq_orphan_path orphan.id
    i_should_see_unsponsored
  end

  def a_sponsor_exists(sponsor_name)
    create :sponsor, name: sponsor_name, requested_orphan_count: 2
  end

  def an_orphan_exists(orphan_name)
    create :orphan, name: orphan_name
  end

  def given_sponsor_on_hold(sponsor_name)
    on_hold_status = Status.find_by name: 'On Hold'
    create :sponsor, name: sponsor_name, status: on_hold_status
  end

  def given_inactive_sponsor(sponsor_name)
    inactive_status = Status.find_by name: 'Inactive'
    create :sponsor, name: sponsor_name, status: inactive_status
  end

  def i_should_see_one_active_sponsorship orphan
    within(".active_sponsors_index") do
      expect(page).to have_selector "tbody tr", count: 1
      expect(page).to have_content orphan.name
    end
    expect(page).to_not have_css(".inactive_sponsors_index")
  end

  def i_should_see_one_inactive_sponsorship orphan
    within(".inactive_sponsors_index") do
      expect(page).to have_selector "tbody tr", count: 1
      expect(page).to have_content orphan.name
    end
    expect(page).to_not have_css(".active_sponsors_index")
  end

  def i_should_see_no_sponsorships
    expect(page).to_not have_css(".inactive_sponsors_index")
    expect(page).to_not have_css(".active_sponsors_index")
  end

  def i_should_see_previously_sponsored
    expect(page).to have_content "Previously sponsored"
  end

  def i_should_see_unsponsored
    expect(page).to have_content "Unsponsored"
  end

  def given_sponsor_sponsors_orphan(sponsor, orphan)
    sponsorship = sponsor.sponsorships.build(orphan_id: orphan.id,
                                             start_date: Date.today)
    @sponsorship_creator = CreateSponsorship.new(sponsorship)
    status = @sponsorship_creator.call
    expect(sponsor.active_sponsorship_count).to eq(1)
  end

  def visit_sponsor(sponsor_name)
    sponsor = Sponsor.find_by name: sponsor_name
    visit hq_sponsor_path sponsor.id
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

  def and_i_should_see_within(panel, orphan_name)
    panel_id = "##{panel.parameterize('_')}"
    within(panel_id) { expect(page).to have_content orphan_name }
  end

end
