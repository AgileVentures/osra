class SponsorType < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
  
end
