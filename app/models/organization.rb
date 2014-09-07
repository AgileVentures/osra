class Organization < ActiveRecord::Base
  after_initialize :set_defaults

  validates :code, presence: true, length: { is: 2 }
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
