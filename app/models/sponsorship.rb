class Sponsorship < ActiveRecord::Base

  include Initializer

  after_initialize :default_start_date_to_today
  before_create :set_orphan_status_to_sponsored, :set_active_to_true
  before_destroy :set_orphan_status_to_unsponsored

  validates :sponsor, presence: true
  validates :orphan, presence: true
  validates :start_date, date_not_in_future: true
  validates :sponsor, uniqueness: { scope: [:orphan, :active],
                                       message: 'already actively sponsors this orphan' }

  belongs_to :sponsor
  belongs_to :orphan

  delegate :name, :additional_info, :id, to: :sponsor, prefix: true
  delegate :date_of_birth, :gender, to: :orphan, prefix: true

  def inactivate
    update_attribute(:active, false)
    set_orphan_status_to_unsponsored
  end

  private

    def set_orphan_status_to_sponsored
      self.orphan.set_status_to_sponsored
    end

    def set_orphan_status_to_unsponsored
      self.orphan.set_status_to_unsponsored
    end

    def set_active_to_true
      self.active = true
    end
end
