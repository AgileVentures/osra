class Sponsorship < ActiveRecord::Base

  include Initializer

  before_create :set_orphan_status_to_sponsored
  before_validation(on: :create) { :set_active_to_true }
  after_save :update_sponsor_request_fulfilled

  validates :sponsor, presence: true
  validates :orphan, presence: true
  
  validate  :start_date_no_later_than_1st_of_next_month, if: :start_date
  validates :start_date, presence: { scope: true, message: "is invalid"}
  
  validates :orphan, uniqueness: { scope: :active,
                                       message: 'is already actively sponsored' }, if: :active
  validate :sponsor_is_eligible_for_new_sponsorship, on: :create
  validate :orphan_is_eligible_for_new_sponsorship, on: :create

  belongs_to :sponsor
  belongs_to :orphan

  delegate :name, :additional_info, :id, to: :sponsor, prefix: true
  delegate :date_of_birth, :gender, to: :orphan, prefix: true

  def inactivate(end_date= Date.current)
    update_attributes!(active: false, end_date: end_date)
    set_orphan_status_to_previously_sponsored
  end

  scope :all_active, -> { where(active: true) }
  scope :all_inactive, -> { where(active: false) }

private
  
  def start_date_no_later_than_1st_of_next_month
    today = Date.current
    first_of_next_month = (today - today.day+1) + 1.month
    if (self.start_date > first_of_next_month)
      errors[:start_date] << "can not be later than the first of next month"
    end
  end

  def set_orphan_status_to_sponsored
    self.orphan.update_sponsorship_status! 'Sponsored'
  end

  def update_sponsor_request_fulfilled
    self.sponsor.update_request_fulfilled!
  end

  def set_orphan_status_to_previously_sponsored
    self.orphan.update_sponsorship_status! 'Previously Sponsored'
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
