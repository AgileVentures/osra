require 'date_validator'

class Partner < ActiveRecord::Base
  include DateValidator
  before_create :set_defaults

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
end
