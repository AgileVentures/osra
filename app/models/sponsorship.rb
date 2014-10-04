class Sponsorship < ActiveRecord::Base

  include Initializer

  after_initialize :default_start_date_to_today
  before_create :set_orphan_status_to_sponsored
  before_validation(on: :create) { :set_active_to_true }
  before_destroy :set_orphan_status_to_unsponsored

  validates :sponsor, presence: true
  validates :orphan, presence: true
  validates :start_date, date_not_in_future: true
  validates :orphan, uniqueness: { scope: :active,
                                       message: 'is already actively sponsored' }, if: :active
  validate :sponsor_is_eligible_for_new_sponsorship, on: :create
  validate :orphan_is_eligible_for_new_sponsorship, on: :create

  belongs_to :sponsor
  belongs_to :orphan

  delegate :name, :additional_info, :id, to: :sponsor, prefix: true
  delegate :date_of_birth, :gender, to: :orphan, prefix: true

  def inactivate
    update_attributes!(active: false)
    set_orphan_status_to_previously_sponsored
  end

  scope :all_active, -> { where(active: true) }
  scope :all_inactive, -> { where(active: false) }

  private

    def set_orphan_status_to_sponsored
      self.orphan.set_status_to_sponsored
    end

    def set_orphan_status_to_previously_sponsored
      self.orphan.set_status_to_previously_sponsored
    end

    def set_active_to_true
      self.active = true
    end

    def sponsor_is_eligible_for_new_sponsorship
      unless sponsor && sponsor.eligible_for_sponsorship?
        errors[:sponsor] << 'is ineligible for a new sponsorship'
      end
    end

    def orphan_is_eligible_for_new_sponsorship
      unless orphan && orphan.eligible_for_sponsorship?
        errors[:orphan] << 'is ineligible for a new sponsorship'
      end
    end
end
