class Province < ActiveRecord::Base

  PROVINCE_CODES = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 29]

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true, inclusion: { in: PROVINCE_CODES}

  has_many :partners
  
  def self.all_names_by_code
    Province.all.order(:code).map(&:name)
  end

end
