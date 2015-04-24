Province.create(name: 'Damascus & Rif Dimashq', code: 11)
Province.create(name: 'Aleppo', code: 12)
Province.create(name: 'Homs', code: 13)
Province.create(name: 'Hama', code: 14)
Province.create(name: 'Latakia', code: 15)
Province.create(name: 'Deir Al-Zor', code: 16)
Province.create(name: 'Daraa', code: 17)
Province.create(name: 'Idlib', code: 18)
Province.create(name: 'Ar Raqqah', code: 19)
Province.create(name: 'Al Hasakah', code: 20)
Province.create(name: 'Tartous', code: 21)
Province.create(name: 'Al-Suwayada', code: 22)
Province.create(name: 'Al-Quneitera', code: 23)
Province.create(name: 'Outside Syria', code: 29)

Status.create(name: 'Active', code: 1)
Status.create(name: 'Inactive', code: 2)
Status.create(name: 'On Hold', code: 3)

SponsorType.create(name: 'Individual', code: 1)
SponsorType.create(name: 'Organization', code: 2)

Branch.create(name: 'Riyadh', code: 1)
Branch.create(name: 'Jeddah', code: 2)
Branch.create(name: 'Dammam', code: 3)
Branch.create(name: 'Dubai', code: 11)
Branch.create(name: 'London', code: 21)

Organization.create(name: 'أهل الغربة وقت الكربة', code: 51)
Organization.create(name: 'حملة بنات الحرمين لنصرة الشعب السوري', code: 52)
Organization.create(name: 'مجموعة السراج للتنمية والرعاية الصحية', code: 53)

if Rails.env.development?
  require "#{Rails.root}/db/seeds/development_seeds.rb"
end
