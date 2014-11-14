class Father < ActiveRecord::Base

  validates :name, presence: true
  validates :is_alive?, inclusion: { in: [true, false] }, exclusion: { in: [nil] }

  has_many :orphans
end
