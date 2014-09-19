class Sponsorship < ActiveRecord::Base

  include Initializer

  after_initialize :default_start_date_to_today

  validates :sponsor, presence: true
  validates :orphan, presence: true
  validates :start_date, date_not_in_future: true

  belongs_to :sponsor
  belongs_to :orphan

  delegate :name, :additional_info, to: :sponsor, prefix: true
end
