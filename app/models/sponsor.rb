class Sponsor < ActiveRecord::Base
  include Initializer
  include DateHelpers

  NEW_CITY_MENU_OPTION = '**Add New**'
  PAYMENT_PLANS = ['Monthly', 'Every Two Months', 'Every Four Months', 'Every Six Months', 'Annually', 'Other']
  PRIORITY_COUNTRIES= %w(SA TR AE GB)
  EXCLUDED_COUNTRYS= %w(IL)

  self.per_page = 10
  attr_accessor :new_city_name
  attr_readonly :branch_id, :organization_id, :sponsor_type_id

  after_initialize :default_status_to_active,
                   :default_start_date_to_today,
                   :default_type_to_individual
  before_create :generate_osra_num, :set_request_unfulfilled
  before_update :set_request_fulfilled, if: 'requested_orphan_count_changed?'
  before_validation :set_city

  validates :name, presence: true
  validates :requested_orphan_count, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :country, presence: true, inclusion: { in: ISO3166::Country.countries.map { |c| c[1] } - ['IL'] }
  validates :city, presence: true,
            exclusion: { in: [NEW_CITY_MENU_OPTION],
                         message: 'Please enter city name below. &darr;' }
  validates :request_fulfilled, inclusion: { in: [true, false] }
  validates :sponsor_type, presence: true
  validates :gender, inclusion: { in: Settings.lookup.gender }
  validates :payment_plan, allow_nil: false, allow_blank: true, inclusion: { in: PAYMENT_PLANS }
  validates :start_date, valid_date_presence: true,
                         date_beyond_osra_establishment: true,
                         date_not_beyond_first_of_next_month: true
  validate :belongs_to_one_branch_or_organization
  validate :can_be_inactivated, if: :being_inactivated?, on: :update
  validates_format_of :email,
      with: /\A([\!\#\$\%\&\'\*\+\-\/\=\?\^\_\`\{\|\}\~[[:word:]]]+)(\.[\!\#\$\%\&\'\*\+\-\/\=\?\^\_\`\{\|\}\~[[:word:]]]+)*\@([\!\#\$\%\&\'\*\+\-\/\=\?\^\_\`\{\|\}\~[[:word:]]]+\.)+([[:word:]]+)(\:[0-9]+)?\z/i,
      allow_blank: true
  validate :type_matches_affiliation, on: :create
  validates :agent, presence: true

  belongs_to :branch
  belongs_to :organization
  belongs_to :status
  belongs_to :sponsor_type
  has_many :sponsorships
  has_many :orphans, through: :sponsorships
  belongs_to :agent, :class_name => 'User', :foreign_key => 'agent_id'

  acts_as_sequenced scope: [:organization_id, :branch_id]

  def affiliate
    branch.present? ? branch.name : organization.name
  end

  def eligible_for_sponsorship?
    self.status.active? && !self.request_fulfilled?
  end

  def currently_sponsored_orphans
    Orphan.joins(:sponsorships).
      where(sponsorships: { sponsor_id: self.id, active: true } )
  end

  def self.all_cities
    pluck(:city).uniq
  end

  scope :all_active, -> { joins(:status).where(statuses: { name: ['Active', 'On Hold'] } ) }
  scope :all_inactive, -> { joins(:status).where(statuses: { name: 'Inactive' } ) }

  private

  def default_type_to_individual
    self.sponsor_type ||= SponsorType.find_by_name 'Individual'
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
    UpdateSponsorSponsorshipData.new(self).call
  end

  def can_be_inactivated
    unless sponsorships.all_active.empty?
      errors[:status] << 'Cannot inactivate sponsor with active sponsorships'
    end
  end

  def being_inactivated?
    status_id_changed? && (Status.find(status_id).name == 'Inactive')
  end

  def type_matches_affiliation
    if type_affiliation_mismatch
      errors[:sponsor_type] << 'Sponsor type must match affiliation'
    end
  end

  def type_affiliation_mismatch
    if sponsor_type
      (sponsor_type.name == 'Individual' && branch.nil?) || (sponsor_type.name == 'Organization' && organization.nil?)
    end
  end

  def set_city
    if (city == NEW_CITY_MENU_OPTION) && new_city_name.present?
      self.city = new_city_name
    end
  end
end
