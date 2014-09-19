class OrphanSponsorshipStatus < ActiveRecord::Base

  has_many :orphans
  validates :name, presence: true, uniqueness: true

  has_many :sponsorships
end
