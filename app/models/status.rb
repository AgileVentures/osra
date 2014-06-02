class Status < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_uniqueness_of :code

  validates_presence_of :name
  validates_presence_of :code

  has_many :partners
end