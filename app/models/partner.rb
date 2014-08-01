require 'date_validator'

class Partner < ActiveRecord::Base
  include DateValidator
  before_create :set_defaults, :generate_osra_num

  validates :name, presence: true, uniqueness: true
  validates :province, presence: true

  belongs_to :province
  belongs_to :status

  acts_as_sequenced scope: :province_id

  validate :validate_date_not_in_future

  private

  def set_defaults
    self.status ||= Status.find_by_name("Under Revision")
    self.partnership_start_date ||= Date.today
  end

  def generate_osra_num
    self.osra_num = province.code.to_s + "%03d" % sequential_id
  end
end
