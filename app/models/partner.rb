class Partner < ActiveRecord::Base

  validates_presence_of (:name)
  validates_presence_of (:province)

  belongs_to :province

end
