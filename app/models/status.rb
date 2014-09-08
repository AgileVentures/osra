class Status < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  has_many :organizations
  has_many :partners
  has_many :sponsors
end