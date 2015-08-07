class Partner < ActiveRecord::Base
  include Initializer

  self.per_page = 10
  attr_readonly :province_id

  after_initialize :default_status_to_active, :default_start_date_to_today
  before_create :generate_osra_num

  validates :name, presence: true, uniqueness: true
  validates :province_id, presence: true
  validates :status_id, presence: true
  validates :start_date, valid_date_presence: true,
                         date_not_in_future: true,
                         date_beyond_osra_establishment: true

  belongs_to :province
  belongs_to :status
  has_many :orphan_lists
  has_many :orphans, through: :orphan_lists

  delegate :code, to: :province, prefix: true

  acts_as_sequenced scope: :province_id

  def active?
    status && status.name == 'Active'
  end

  def self.all_names
    Partner.order(:name).map(&:name)
  end

  private

  def generate_osra_num
    self.osra_num = province.code.to_s + "%03d" % sequential_id
  end
end
