class Father < ActiveRecord::Base

  enum status: %i(dead alive)
  enum martyr_status: %i(not_martyr martyr)

  belongs_to :orphan

  validates :name, presence: true
  validates :status, presence: true
  validates :martyr_status, presence: true
  validates :orphan_id, presence: true, uniqueness: true

  # alive / dead / martyr / dates validations
  # invalid without at least one orphan - orphan before_destroy :destroy_father_if_no_orphans
end
