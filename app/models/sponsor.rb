class Sponsor < ActiveRecord::Base
  include Initializer

  after_initialize :default_status_to_under_revision, :default_start_date_to_today
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

  private
  
  def belongs_to_one_branch_or_organization
    if branch.blank? && organization.blank?
      errors.add(:organization, "must belong to a branch or an organization")
      errors.add(:branch, "must belong to a branch or an organization")
    end
    if branch.present? && organization.present?
      errors.add(:organization, "cannot belong to both a branch and an organization")
      errors.add(:branch, "cannot belong to both a branch and an organization")
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

end
