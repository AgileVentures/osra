AdminUser.delete_all
AdminUser.create(email: 'admin@example.com',
                 password: 'password',
                 password_confirmation: 'password')

User.delete_all
2.times { FactoryGirl.create :user }

Sponsor.delete_all
Sponsorship.delete_all
FactoryGirl.create :sponsor,
                   sponsor_type: SponsorType.find_by_name('Individual'),
                   branch: Branch.find_by_name('Riyadh'),
                   agent: User.first
FactoryGirl.create :sponsor,
                   sponsor_type: SponsorType.find_by_name('Organization'),
                   organization: Organization.find_by_name('أهل الغربة وقت الكربة'),
                   branch: nil,
                   agent: User.last

Partner.delete_all
FactoryGirl.create :partner,
                   province: Province.find_by_name('Homs')
FactoryGirl.create :partner,
                   province: Province.find_by_name('Aleppo')

OrphanList.delete_all
list1 = FactoryGirl.create :orphan_list, partner: Partner.first
list2 = FactoryGirl.create :orphan_list, partner: Partner.last

Orphan.delete_all
3.times { FactoryGirl.create :orphan, orphan_list: list1 }
2.times { FactoryGirl.create :orphan, orphan_list: list2 }
