class Orphan < ActiveRecord::Base

  include Initializer
  after_initialize :default_orphan_status_active,
                   :default_sponsorship_status_unsponsored,
                   :default_priority_to_normal
  before_update :qualify_for_sponsorship_by_status,
                if: :orphan_status_id_changed?

  before_validation :set_province_code

  before_create :generate_osra_num

  validates :name, presence: true
  validates :father_name, presence: true
  validates :father_is_martyr, inclusion: {in: [true, false] }, exclusion: { in: [nil]}
  validates :father_date_of_death, presence: true, date_not_in_future: true
  validates :mother_name, presence: true
  validates :mother_alive, inclusion: {in: [true, false] }, exclusion: { in: [nil]}
  validates :father_alive, inclusion: {in: [true, false] }, exclusion: { in: [nil]}
  validates :date_of_birth, presence: true, date_not_in_future: true
  validates :gender, presence: true, inclusion: {in: Settings.lookup.gender }
  validates :contact_number, presence: true
  validates :sponsored_by_another_org, inclusion: {in: [true, false] }, exclusion: { in: [nil]}
  validates :minor_siblings_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :original_address, presence: true
  validates :current_address, presence: true
  validates :orphan_status, presence: true
  validates :priority, presence: true, inclusion: { in: %w(Normal High) }
  validates :orphan_sponsorship_status, presence: true
  validates :orphan_list, presence: true
  validate :orphans_dob_within_1yr_of_fathers_death
  validate :less_than_22_yo_when_joined_osra
  validate :can_be_inactivated, if: :being_inactivated?, on: :update

  has_one :original_address, foreign_key: 'orphan_original_address_id', class_name: 'Address'
  has_one :current_address, foreign_key: 'orphan_current_address_id', class_name: 'Address'
  has_many :sponsorships
  has_many :sponsors, through: :sponsorships

  belongs_to :orphan_status
  belongs_to :orphan_sponsorship_status
  belongs_to :orphan_list
  has_one :partner, through: :orphan_list, autosave: false

  delegate :province_code, to: :partner, prefix: true

  accepts_nested_attributes_for :current_address, allow_destroy: true
  accepts_nested_attributes_for :original_address, allow_destroy: true

  def full_name
    [name, father_name].join(' ')
  end

  def orphans_dob_within_1yr_of_fathers_death
    # gestation is considered vaild if within 1 year of a fathers death
    return unless valid_date?(father_date_of_death) && valid_date?(date_of_birth)
    if (father_date_of_death + 1.year) < date_of_birth
      errors.add(:date_of_birth, 'date of birth must be within the gestation period of fathers death')
    end
  end

  def update_sponsorship_status!(status_name)
    sponsorship_status = OrphanSponsorshipStatus.find_by_name(status_name)
    update!(orphan_sponsorship_status: sponsorship_status)
  end

  scope :active,
        -> { joins(:orphan_status).
            where(orphan_statuses: { name: 'Active' }) }
  scope :currently_unsponsored,
        -> { joins(:orphan_sponsorship_status).
            where(orphan_sponsorship_statuses: { name: ['Unsponsored', 'Previously Sponsored'] }) }
  scope :high_priority, -> { where(priority: 'High') }

  acts_as_sequenced scope: :province_code

  def eligible_for_sponsorship?
    Orphan.active.currently_unsponsored.include? self
  end

  def less_than_22_yo_when_joined_osra
    return unless valid_date?(date_of_birth)
    reference_date = self.new_record? ? Date.current : self.created_at.to_date
    if self.date_of_birth + 22.years <= reference_date
      errors.add :date_of_birth, "Orphan must be younger than 22 years old."
    end
  end

  def currently_sponsored?
    sponsorships.all_active.present?
  end

  def current_sponsorship
    sponsorships.all_active.first if currently_sponsored?
  end

  def current_sponsor
    current_sponsorship.sponsor if currently_sponsored?
  end

  private

  def default_sponsorship_status_unsponsored
    self.orphan_sponsorship_status ||= OrphanSponsorshipStatus.find_by_name 'Unsponsored'
  end

  def default_orphan_status_active
     self.orphan_status ||= OrphanStatus.find_by_name 'Active'
  end

  def valid_date? date
    begin 
      Date.parse(date.to_s)
    rescue ArgumentError
      return false
    end
  end

  def default_priority_to_normal
    self.priority ||= 'Normal'
  end
  

  def set_province_code
    self.province_code = partner_province_code
  end

  def generate_osra_num
    self.osra_num = "#{province_code}%05d" % sequential_id
  end

  def qualify_for_sponsorship_by_status
    if orphan_status_is_active?
      reactivate
    elsif orphan_status_was_active?
      deactivate
    end
  end

  def orphan_status_is_active?
    orphan_status.name == 'Active'
  end

  def orphan_status_was_active?
    OrphanStatus.find(orphan_status_id_was).name == 'Active'
  end

  def deactivate
    self.orphan_sponsorship_status = OrphanSponsorshipStatus.find_by_name 'On Hold'
  end

  def reactivate
    if unsponsored?
      set_sponsorship_status 'Unsponsored'
    elsif previously_sponsored?
      set_sponsorship_status 'Previously Sponsored'
    elsif currently_sponsored?
      set_sponsorship_status 'Sponsored'
    end
  end

  def unsponsored?
    self.sponsorships.empty?
  end

  def previously_sponsored?
    self.sponsorships.all_active.empty?
  end

  def set_sponsorship_status(status_name)
    sponsorship_status = OrphanSponsorshipStatus.find_by_name(status_name)
    self.orphan_sponsorship_status = sponsorship_status
  end

  def can_be_inactivated
    if currently_sponsored?
      errors[:orphan_status] << 'Cannot inactivate orphan with active sponsorships'
    end
  end

  def being_inactivated?
    unless orphan_status_id_was.nil?
      orphan_status_id_changed? && (OrphanStatus.find(orphan_status_id_was).name == 'Active')
    end
  end
end
