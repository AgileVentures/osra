class Province < ActiveRecord::Base

  PROVINCE_CODES = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 29]

  validates_presence_of :name, :code
  validates_inclusion_of :code, in: PROVINCE_CODES

  validates_uniqueness_of :name, :code
  has_many :partners

end
