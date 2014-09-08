class OrphanList < ActiveRecord::Base
  before_create :generate_osra_num

  validates_presence_of :partner, :orphan_count, :file

  belongs_to :partner

  acts_as_sequenced scope: :partner_id

  private

  def generate_osra_num
    self.osra_num = "%04d" % sequential_id
  end
end
