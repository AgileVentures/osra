require 'date_validator'

class Sponsor < ActiveRecord::Base

  include DateValidator
  before_create :set_defaults, :generate_osra_num

  validates_presence_of (:name)
  validates_presence_of (:country)

  belongs_to :status

  validate :validate_date_not_in_future

  def set_defaults
    self.status ||= Status.find_by_name("Under Revision")
    self.sponsorship_start_date ||= Date.today
  end

  def generate_osra_num
  end

end
