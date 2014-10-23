Given(/^required orphan statuses exist$/) do
  FactoryGirl.create :orphan_status, name: 'Active' unless
      OrphanStatus.find_by_name 'Active'
  FactoryGirl.create :orphan_status, name: 'Inactive' unless
      OrphanStatus.find_by_name 'Inactive'
  FactoryGirl.create :orphan_sponsorship_status, name: 'Sponsored' unless
      OrphanSponsorshipStatus.find_by_name 'Sponsored'
  FactoryGirl.create :orphan_sponsorship_status, name: 'Unsponsored' unless
      OrphanSponsorshipStatus.find_by_name 'Unsponsored'
  FactoryGirl.create :orphan_sponsorship_status, name: 'Previously Sponsored' unless
      OrphanSponsorshipStatus.find_by_name 'Previously Sponsored'
end

Given(/^required statuses exist$/) do
  FactoryGirl.create :status, name: 'Active' unless
      Status.find_by_name 'Active'
  FactoryGirl.create :status, name: 'Inactive' unless
      Status.find_by_name 'Inactive'
  FactoryGirl.create :status, name: 'On Hold' unless
      Status.find_by_name 'On Hold'
end
