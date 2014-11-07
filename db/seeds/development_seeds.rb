AdminUser.create(email: 'admin@example.com',
                 password: 'password',
                 password_confirmation: 'password')
User.create(email: 'tarek@osra.org', user_name: 'Tarek Al Wafai')
User.create(email: 'ahmed@osra.org', user_name: 'Ahmed Abdulmawla')
FactoryGirl.create :sponsor,
                   sponsor_type: SponsorType.find_by_name('Individual'),
                   branch: Branch.find_by_name('Riyadh')
FactoryGirl.create :sponsor,
                   sponsor_type: SponsorType.find_by_name('Organization'),
                   organization: Organization.find_by_name('أهل الغربة وقت الكربة'),
                   branch: nil
FactoryGirl.create :partner,
                   province: Province.find_by_name('Homs')
FactoryGirl.create :partner,
                   province: Province.find_by_name('Aleppo')
3.times { FactoryGirl.create :orphan }
