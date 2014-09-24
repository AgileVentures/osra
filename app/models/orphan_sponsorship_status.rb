class OrphanSponsorshipStatus < ActiveRecord::Base

  has_many :orphans
  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
end
