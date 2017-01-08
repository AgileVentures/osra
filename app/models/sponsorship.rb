class Sponsorship < ActiveRecord::Base

  include Initializer

  before_validation(on: :create) { :set_active_to_true }

  validates :sponsor, presence: true
  validates :orphan, presence: true

  validates :start_date, valid_date_presence: true,
                         date_beyond_osra_establishment: true,
                         date_not_beyond_first_of_next_month: true

  validates :end_date, valid_date_presence: true, if: '!active'
  validate  :end_date_not_before_start_date, on: :update, if: :end_date

  validates :orphan, uniqueness: { scope: :active,
                                       message: 'is already actively sponsored' }, if: :active
  validate :sponsor_is_eligible_for_new_sponsorship, on: :create
  validate :orphan_is_eligible_for_new_sponsorship, on: :create

  has_one :cashbox, as: :cashboxable, dependent: :destroy
  belongs_to :sponsor
  belongs_to :orphan

  delegate :name, :additional_info, to: :sponsor, prefix: true
  delegate :date_of_birth, :gender, to: :orphan, prefix: true

  scope :all_active, -> { where(active: true) }
  scope :all_inactive, -> { where(active: false) }

private

  def start_date_no_later_than_1st_of_next_month
    first_of_next_month = Date.current.beginning_of_month.next_month
    if (self.start_date > first_of_next_month)
      errors[:start_date] << "can not be later than the first of next month"
    end
  end

  def end_date_not_before_start_date
    unless end_date >= start_date
      errors[:end_date] << "can't be before the starting date (#{self.start_date})"
    end
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
