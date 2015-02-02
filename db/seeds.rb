Province.where(name: 'Damascus & Rif Dimashq', code: 11).first_or_create!
Province.where(name: 'Aleppo', code: 12).first_or_create!
Province.where(name: 'Homs', code: 13).first_or_create!
Province.where(name: 'Hama', code: 14).first_or_create!
Province.where(name: 'Latakia', code: 15).first_or_create!
Province.where(name: 'Deir Al-Zor', code: 16).first_or_create!
Province.where(name: 'Daraa', code: 17).first_or_create!
Province.where(name: 'Idlib', code: 18).first_or_create!
Province.where(name: 'Ar Raqqah', code: 19).first_or_create!
Province.where(name: 'Al Hasakah', code: 20).first_or_create!
Province.where(name: 'Tartous', code: 21).first_or_create!
Province.where(name: 'Al-Suwayada', code: 22).first_or_create!
Province.where(name: 'Al-Quneitera', code: 23).first_or_create!
Province.where(name: 'Outside Syria', code: 29).first_or_create!

Status.where(name: 'Active', code: 1).first_or_create!
Status.where(name: 'Inactive', code: 2).first_or_create!
Status.where(name: 'On Hold', code: 3).first_or_create!

OrphanStatus.where(name: 'Active', code: 1).first_or_create!
OrphanStatus.where(name: 'Inactive', code: 2).first_or_create!
OrphanStatus.where(name: 'On Hold', code: 3).first_or_create!
OrphanStatus.where(name: 'Under Revision', code: 4).first_or_create!

SponsorType.where(name: 'Individual', code: 1).first_or_create!
SponsorType.where(name: 'Organization', code: 2).first_or_create!

Branch.where(name: 'Riyadh', code: 1).first_or_create!
Branch.where(name: 'Jeddah', code: 2).first_or_create!
Branch.where(name: 'Dammam', code: 3).first_or_create!
Branch.where(name: 'Dubai', code: 11).first_or_create!
Branch.where(name: 'London', code: 21).first_or_create!

OrphanSponsorshipStatus.where(name: 'Unsponsored',          code: 1).first_or_create!
OrphanSponsorshipStatus.where(name: 'Sponsored',            code: 2).first_or_create!
OrphanSponsorshipStatus.where(name: 'Previously Sponsored', code: 3).first_or_create!
OrphanSponsorshipStatus.where(name: 'On Hold',              code: 4).first_or_create!

Organization.where(name: 'أهل الغربة وقت الكربة', code: 51).first_or_create!
Organization.where(name: 'حملة بنات الحرمين لنصرة الشعب السوري', code: 52).first_or_create!
Organization.where(name: 'مجموعة السراج للتنمية والرعاية الصحية', code: 53).first_or_create!

if Rails.env.development?
  require "#{Rails.root}/db/seeds/development_seeds.rb"
end
