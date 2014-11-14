class Father < ActiveRecord::Base

  enum status: %i(dead alive)
  enum martyr_status: %i(not_martyr martyr)

  validates :name, presence: true
  validates :status, presence: true
  validates :martyr_status, presence: true

  has_many :orphans

  # alive / dead / martyr / dates validations
  # invalid without at least one orphan - orphan before_destroy :destroy_father_if_no_orphans
end
