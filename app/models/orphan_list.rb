class OrphanList < ActiveRecord::Base
  validates_presence_of :osra_num, :partner, :orphan_count, :file
  validates_uniqueness_of :osra_num

  belongs_to :partner
end
