class Organization < ActiveRecord::Base
  after_initialize :set_defaults
  after_create :generate_code_num

  #validates :code, presence: true
  validates :name, presence: true, uniqueness: true
  validates :country, presence: true
  validates :status_id, presence: true
  validates :start_date, date_not_in_future: true

  belongs_to :status

  #acts_as_sequenced scope: :status_id

  private

  def set_defaults
    self.status ||= Status.find_by_name("Under Revision")
    self.start_date ||= Date.current
  end

  def generate_code_num
    #self.code = self.status.id.to_s + "%02d" % self.sequential_id
  end

end
