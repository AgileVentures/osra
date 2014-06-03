require 'date_validator'

class Partner < ActiveRecord::Base
  include DateValidator
  before_create :set_defaults, :generate_osra_num

  validates_presence_of (:name)
  validates_presence_of (:province)

  belongs_to :province
  belongs_to :status

  validate :validate_date_not_in_future

  private

  def set_defaults
    self.status ||= Status.find_by_name("Under Revision")
    self.partnership_start_date ||= Date.today
  end

  def generate_osra_num

    province_partners = Province.find(province_id).partners

    unless province_partners.empty?
      seq = province_partners.last.osra_num[2..-1].to_i + 1
    else
      seq = 1
    end

    self.osra_num = province.code.to_s + "%03d" % seq
  end
end
