class Sponsor < ActiveRecord::Base
  include Initializer

  after_initialize :default_status_to_active, :default_start_date_to_today
  before_create :generate_osra_num

  validates :name, presence: true
  validates :country, presence: true
  validates :sponsor_type, presence: true
  validates :gender, inclusion: {in: %w(Male Female) } # TODO: DRY list of allowed values
  validates :start_date, date_not_in_future: true
  validate :belongs_to_one_branch_or_organization

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

  def eligible_for_sponsorship
    self.status.active
  end

  private
  
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
    elsif organization.present?
      "8%02d" % organization.code
    else
      errors[:base] << "must belong to a branch or an organization, but not both"
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

end
