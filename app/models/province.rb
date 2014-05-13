class Province < ActiveRecord::Base

  PROVINCE_CODES = [11,12,13,14,15,16,17,18,19,29]

  validates_presence_of :name
  validates_inclusion_of :code, in: PROVINCE_CODES
  has_many :partners

end
