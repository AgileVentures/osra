AdminUser.create(email: 'admin@example.com',
                 password: 'password',
                 password_confirmation: 'password')
User.create(email: 'user1@example.com',
            password: 'password',
            password_confirmation: 'password')
User.create(email: 'user2@example.com',
            password: 'password',
            password_confirmation: 'password')
FactoryGirl.create :organization,
                   status: Status.find_by_name('Active')
FactoryGirl.create :organization,
                   status: Status.find_by_name('Inactive')
FactoryGirl.create :sponsor,
                   sponsor_type: SponsorType.find_by_name('Individual')
FactoryGirl.create :sponsor,
                   sponsor_type: SponsorType.find_by_name('Organization')
FactoryGirl.create :partner,
                   province: Province.find_by_name('Homs')
FactoryGirl.create :partner,
                   province: Province.find_by_name('Aleppo')
FactoryGirl.create :address,
                   province: Province.find_by_name('Homs')
FactoryGirl.create :address,
                   province: Province.find_by_name('Aleppo')
FactoryGirl.create :orphan,
                   original_address: Address.find(1),
                   current_address: Address.find(2),
                   orphan_status: OrphanStatus.find_by_name('Sponsored')
FactoryGirl.create :orphan,
                   original_address: Address.find(1),
                   current_address: Address.find(2),
                   orphan_status: OrphanStatus.find_by_name('Unsponsored')
FactoryGirl.create :orphan,
                   original_address: Address.find(1),
                   current_address: Address.find(2),
                   orphan_status: OrphanStatus.find_by_name('Unsponsored')

# Organization.create(name: 'First Organization',
#                     code: 11,
#                     country: 'UK')
# Organization.create(name: 'Second Organization',
#                     code: 90,
#                     country: 'US')
# Sponsor.create(name: 'First Sponsor',
#                country: 'UK',
#                sponsor_type: SponsorType.find(1),
#                gender: 'Male')
# Sponsor.create(name: 'Second Sponsor',
#                country: 'US',
#                sponsor_type: SponsorType.find(2),
#                gender: 'Female')
# Partner.create(name: 'First Partner',
#                province: Province.find(1))
# Partner.create(name: 'Second Partner',
#                province: Province.find(2))
# Address.create(province: Province.find(1),
#                city: 'Atlantis',
#                neighborhood: 'Shady Oaks')
# Address.create(province: Province.find(2),
#                city: 'El Dorado',
#                neighborhood: 'Leafy Elms')
# Orphan.create(name: 'First',
#               father_name: 'Father',
#               father_is_martyr: false,
#               father_date_of_death: 1.year.ago,
#               mother_name: 'Mother',
#               mother_alive: true,
#               date_of_birth: 2.years.ago,
#               gender: 'Male',
#               contact_number: '123456789',
#               sponsored_by_another_org: false,
#               minor_siblings_count: 0,
#               original_address: Address.find(1),
#               current_address: Address.find(2),
#               orphan_status: OrphanStatus.find_by_name('Unsponsored'))
# Orphan.create(name: 'Second',
#               father_name: 'Father',
#               father_is_martyr: false,
#               father_date_of_death: 2.months.ago,
#               mother_name: 'Mother',
#               mother_alive: false,
#               date_of_birth: 7.years.ago,
#               gender: 'Female',
#               contact_number: '123456789',
#               sponsored_by_another_org: true,
#               minor_siblings_count: 3,
#               original_address: Address.find(1),
#               current_address: Address.find(2),
#               orphan_status: OrphanStatus.find_by_name('Unsponsored'))
