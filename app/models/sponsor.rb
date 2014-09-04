class Sponsor < ActiveRecord::Base
  include Initializer

  after_initialize :set_status, :set_start_date
  before_create :generate_osra_num

  validates :name, presence: true
  validates :country, presence: true
  validates :sponsor_type, presence: true
  validates :gender, inclusion: {in: %w(Male Female) } # TODO: DRY list of allowed values
  validates :start_date, date_not_in_future: true

  belongs_to :status
  belongs_to :sponsor_type

private

  def generate_osra_num
  end

end
