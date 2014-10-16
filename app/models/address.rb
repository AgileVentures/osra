class Address < ActiveRecord::Base

  validates :province, presence: true
  validates :city, presence: true
  validates :neighborhood, presence: true

  belongs_to :province
end
