class Organization < ActiveRecord::Base
  include Initializer
  after_initialize :default_status_to_under_revision, :default_start_date_to_today

  validates :code, presence: true, uniqueness: true, numericality: {only_integer: true}, inclusion: 0..99 
  validates :name, presence: true, uniqueness: true
  validates :country, presence: true
  validates :status_id, presence: true
  validates :start_date, date_not_in_future: true

  belongs_to :status

  private

  def set_defaults
    self.status ||= Status.find_by_name("Under Revision")
    self.start_date ||= Date.current
  end
end
