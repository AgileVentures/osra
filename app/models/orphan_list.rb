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
  delegate :province_code, to: :partner, prefix: true

  def partner_is_active
    unless partner && partner.active?
      errors.add(:partner, 'is not active')
    end
  end

  private

  def generate_osra_num
    self.osra_num = "%04d" % sequential_id
  end
end
