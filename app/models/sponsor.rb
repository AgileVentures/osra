require 'date_validator'

class Sponsor < ActiveRecord::Base

  include DateValidator
  before_create :set_defaults, :generate_osra_num

  validates :name, presence: true
  validates :country, presence: true
  validates :sponsor_type, presence: true

  belongs_to :status

  belongs_to :sponsor_type

  validate :validate_date_not_in_future

  def set_defaults
    self.status ||= Status.find_by_name("Under Revision")
    self.sponsorship_start_date ||= Date.today
  end

  def generate_osra_num
  end

end
