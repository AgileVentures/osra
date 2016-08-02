class Address < ActiveRecord::Base

  validates :province, presence: true
  validates :city, presence: true
  #validates :neighborhood, presence: true

  belongs_to :province

  scope :original, -> { where.not(orphan_original_address_id: nil) }

  def province_name
    province.name 
  end

end
