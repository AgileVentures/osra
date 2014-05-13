class Status < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_uniqueness_of :code
end