class Branch < ActiveRecord::Base

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true,
            numericality: { only_integer: true}, inclusion: 0..99

  has_many :sponsors

end
