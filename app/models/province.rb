class Province < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true, inclusion: { in: 10..99 }

  has_many :partners

end
