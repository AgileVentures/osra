class Sponsor < ActiveRecord::Base
  include Initializer

  after_initialize :default_status_to_under_revision, :default_start_date_to_today
  before_create :generate_osra_num

  validates :name, presence: true
  validates :country, presence: true
  validates :sponsor_type, presence: true
  validates :gender, inclusion: {in: %w(Male Female) } # TODO: DRY list of allowed values
  validates :start_date, date_not_in_future: true

  belongs_to :branch
  belongs_to :status
  belongs_to :sponsor_type
  has_many :sponsorships
  has_many :orphans, through: :sponsorships

  private

  def generate_osra_num
  end

end
