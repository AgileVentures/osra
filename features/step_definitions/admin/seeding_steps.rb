Given(/^required orphan statuses exist$/) do
  FactoryGirl.create :orphan_sponsorship_status, name: 'Sponsored' unless
      OrphanSponsorshipStatus.find_by_name 'Sponsored'
  FactoryGirl.create :orphan_sponsorship_status, name: 'Unsponsored' unless
      OrphanSponsorshipStatus.find_by_name 'Unsponsored'
  FactoryGirl.create :orphan_sponsorship_status, name: 'Previously Sponsored' unless
      OrphanSponsorshipStatus.find_by_name 'Previously Sponsored'
end
