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
OrphanStatus.create(name: 'Sponsored', code: 1)
OrphanStatus.create(name: 'Unsponsored', code: 2)

# Creating Sponsor Types
SponsorType.create(name: 'Individual', code: 1)
SponsorType.create(name: 'Organization', code: 2)

# Creating Branches
Branch.create(name: 'Riyadh', code: 1)
Branch.create(name: 'Jeddah', code: 2)
Branch.create(name: 'Dammam', code: 3)
Branch.create(name: 'Dubai', code: 11)
Branch.create(name: 'London', code: 21)

SponsorshipStatus.create(name: 'Active', code: 1)
SponsorshipStatus.create(name: 'Inactive', code: 2)

if Rails.env.development?
  AdminUser.create(email: 'admin@example.com',
                   password: 'password',
                   password_confirmation: 'password')
  User.create(email: 'user1@example.com',
              password: 'password',
              password_confirmation: 'password')
  User.create(email: 'user2@example.com',
              password: 'password',
              password_confirmation: 'password')
  Organization.create(name: 'First Organization',
                      code: 11,
                      country: 'UK')
  Organization.create(name: 'Second Organization',
                      code: 90,
                      country: 'US')
  Sponsor.create(name: 'First Sponsor',
                 country: 'UK',
                 sponsor_type: SponsorType.find(1),
                 gender: 'Male')
  Sponsor.create(name: 'Second Sponsor',
                 country: 'US',
                 sponsor_type: SponsorType.find(2),
                 gender: 'Female')
  Partner.create(name: 'First Partner',
                 province: Province.find(1))
  Partner.create(name: 'Second Partner',
                 province: Province.find(2))
  Address.create(province: Province.find(1),
                                    city: 'Atlantis',
                                    neighborhood: 'Shady Oaks')
  Address.create(province: Province.find(2),
                                   city: 'El Dorado',
                                   neighborhood: 'Leafy Elms')
  Orphan.create(name: 'First',
                father_name: 'Father',
                father_is_martyr: false,
                father_date_of_death: 1.year.ago,
                mother_name: 'Mother',
                mother_alive: true,
                date_of_birth: 2.years.ago,
                gender: 'Male',
                contact_number: '123456789',
                sponsored_by_another_org: false,
                minor_siblings_count: 0,
                original_address: Address.find(1),
                current_address: Address.find(2),
                orphan_status: OrphanStatus.find_by_name('Unsponsored'))
  Orphan.create(name: 'Second',
                father_name: 'Father',
                father_is_martyr: false,
                father_date_of_death: 2.months.ago,
                mother_name: 'Mother',
                mother_alive: false,
                date_of_birth: 7.years.ago,
                gender: 'Female',
                contact_number: '123456789',
                sponsored_by_another_org: true,
                minor_siblings_count: 3,
                original_address: Address.find(1),
                current_address: Address.find(2),
                orphan_status: OrphanStatus.find_by_name('Unsponsored'))
end
