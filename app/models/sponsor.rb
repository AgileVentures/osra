class Sponsor < ActiveRecord::Base
  include Initializer

  after_initialize :default_status_to_active,
                   :default_start_date_to_today,
                   :default_type_to_individual
  before_create :generate_osra_num, :set_request_unfulfilled
  before_update :set_request_fulfilled

  validates :name, presence: true
  validates :payment_plan, inclusion: { in: (Sponsor.payment_plans << nil) }
  validates :requested_orphan_count, presence: true,
            numericality: {only_integer: true, greater_than: 0}
  validates :country, presence: true, inclusion:  {in: ISO3166::Country.countries.map {|c| c[1]} - ['IL']}
  validates :request_fulfilled, inclusion: {in: [true, false] }
  validates :sponsor_type, presence: true
  validates :gender, inclusion: {in: %w(Male Female) } # TODO: DRY list of allowed values
  validate :ensure_valid_date
  validate :date_not_beyond_first_of_next_month
  validate :belongs_to_one_branch_or_organization
  validate :can_be_inactivated, if: :being_inactivated?, on: :update

  belongs_to :branch
  belongs_to :organization
  belongs_to :status
  belongs_to :sponsor_type
  has_many :sponsorships
  has_many :orphans, through: :sponsorships

  acts_as_sequenced scope: [:organization_id, :branch_id]

  def affiliate
    branch.present? ? branch.name : organization.name
  end

  def eligible_for_sponsorship?
    self.status.active? && !self.request_fulfilled?
  end

  def update_request_fulfilled!
    update!(request_fulfilled: request_is_fulfilled?)
  end
  
  def self.payment_plans
    ['Monthly', 'Every Two Months', 'Every Four Months', 'Every Six Months', 'Annually', 'Other']
  end

  private

  def date_not_beyond_first_of_next_month
    if (valid_date? start_date) && (start_date > Date.current.beginning_of_month.next_month)
      errors.add(:start_date, "must not be beyond the first of next month")
    end
  end

  def default_type_to_individual
    self.sponsor_type ||= SponsorType.find_by_name 'Individual'
  end

  def ensure_valid_date
    unless valid_date? start_date
      errors.add(:start_date, "is not a valid date")
    end
  end

  def valid_date? test_date
    begin
      Date.parse(test_date.to_s)
    rescue ArgumentError
      false
    end
  end

  def belongs_to_one_branch_or_organization
    unless branch.blank? ^ organization.blank?
      errors.add(:organization, "must belong to a branch or an organization, but not both")
      errors.add(:branch, "must belong to a branch or an organization, but not both")
    end
  end

  def generate_osra_num
    self.osra_num = "#{osra_num_prefix}%04d" % sequential_id
  end

  def osra_num_prefix
    if branch.present?
      "5%02d" % branch.code
    else
      "8%02d" % organization.code
    end
  end

  def set_request_unfulfilled
    self.request_fulfilled = false
    true
  end

  def set_request_fulfilled
    self.request_fulfilled = request_is_fulfilled?
    true
  end

  def can_be_inactivated
    unless sponsorships.all_active.empty?
      errors[:status] << 'Cannot inactivate sponsor with active sponsorships'
    end
  end

  def being_inactivated?
    status_id_changed? && (Status.find(status_id).name == 'Inactive')
  end

  def request_is_fulfilled?
    sponsorships.all_active.count >= requested_orphan_count
  end
end
