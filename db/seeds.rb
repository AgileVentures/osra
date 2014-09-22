# Creating Provinces
Province.create(name: 'Damascus & Rif Dimashq', code: 11)
Province.create(name: 'Aleppo', code: 12)
Province.create(name: 'Homs', code: 13)
Province.create(name: 'Hama', code: 14)
Province.create(name: 'Latakia', code: 15)
Province.create(name: 'Deir Al-Zor', code: 16)
Province.create(name: 'Daraa', code: 17)
Province.create(name: 'Idlib', code: 18)
Province.create(name: 'Ar Raqqah', code: 19)
Province.create(name: 'Al Ḥasakah', code: 20)
Province.create(name: 'Tartous', code: 21)
Province.create(name: 'Al-Suwayada', code: 22)
Province.create(name: 'Al-Quneitera', code: 23)
Province.create(name: 'Outside Syria', code: 29)

# Creating Statuses
Status.create(name: 'Active', code: 1)
Status.create(name: 'Inactive', code: 2)
Status.create(name: 'On Hold', code: 3)
Status.create(name: 'Under Revision', code: 4)

# Creating Orphan Statuses
OrphanStatus.create(name: 'Active', code: 1)
OrphanStatus.create(name: 'Inactive', code: 2)
OrphanStatus.create(name: 'On Hold', code: 3)
OrphanStatus.create(name: 'Under Revision', code: 4)

# Creating Sponsor Types
SponsorType.create(name: 'Individual', code: 1)
SponsorType.create(name: 'Organization', code: 2)

# Creating Branches
Branch.create(name: 'Riyadh', code: 1)
Branch.create(name: 'Jeddah', code: 2)
Branch.create(name: 'Dammam', code: 3)
Branch.create(name: 'Dubai', code: 11)
Branch.create(name: 'London', code: 21)

OrphanSponsorshipStatus.create(name: 'Unsponsored',          code: 1)
OrphanSponsorshipStatus.create(name: 'Sponsored',            code: 2)
OrphanSponsorshipStatus.create(name: 'Previously Sponsored', code: 3)
OrphanSponsorshipStatus.create(name: 'On Hold',              code: 4)

if Rails.env.development?
  require "#{Rails.root}/db/seeds/development_seeds.rb"
end
