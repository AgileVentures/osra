AdminUser.create(email: 'admin@example.com',
                 password: 'password',
                 password_confirmation: 'password')
2.times { FactoryGirl.create :user }
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
13.times { FactoryGirl.create :orphan }
