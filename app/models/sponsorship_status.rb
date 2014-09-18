class SponsorshipStatus < ActiveRecord::Base

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  has_many :sponsorships

  scope :active, -> { where(name: 'Active') }
  scope :inactive, -> { where(name: 'Inactive') }
end
