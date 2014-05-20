class Partner < ActiveRecord::Base
  before_create :set_default_status

  validates_presence_of (:name)
  validates_presence_of (:province)

  belongs_to :province
  belongs_to :status

  private

  def set_default_status
    self.status ||= Status.find_by_name("Under Revision")
  end
end
