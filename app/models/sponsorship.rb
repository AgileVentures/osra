class Sponsorship < ActiveRecord::Base

  include Initializer

  after_initialize :default_start_date_to_today
  before_create :set_orphan_status_to_sponsored
  before_destroy :set_orphan_status_to_unsponsored

  validates :sponsor, presence: true
  validates :orphan, presence: true
  validates :start_date, date_not_in_future: true

  belongs_to :sponsor
  belongs_to :orphan

  delegate :name, :additional_info, :id, to: :sponsor, prefix: true

  private

    def set_orphan_status_to_sponsored
      self.orphan.set_status_to_sponsored
    end

    def set_orphan_status_to_unsponsored
      self.orphan.set_status_to_unsponsored
    end
end
