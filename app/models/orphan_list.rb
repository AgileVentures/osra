class OrphanList < ActiveRecord::Base

  before_create :generate_osra_num

  acts_as_sequenced
  has_attached_file :spreadsheet

  validates :partner, presence: true
  validates :orphan_count, presence: true
  validate :partner_is_active

  validates_attachment :spreadsheet, presence: true,
                       file_name: { matches: [/xls\Z/, /xlsx\Z/] }

  belongs_to :partner
  has_many :orphans, after_add: :set_orphan_count,
                     after_remove: :set_orphan_count

  def partner_is_active
    unless partner && partner.active?
      errors.add(:partner, 'is not active')
    end
  end

  private

  def set_orphan_count orphan
    self.orphan_count = self.orphans.count
  end

  def generate_osra_num
    self.osra_num = "%04d" % sequential_id
  end
end
