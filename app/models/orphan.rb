class Orphan < ActiveRecord::Base
  validates :name, presence: true
  validates :father_name, presence: true
  validates :father_is_martyr, inclusion: {in: [true, false] }, exclusion: { in: [nil]}
  validates :father_date_of_death, presence: true, date_not_in_future: true
  validates :mother_name, presence: true
  validates :mother_alive, inclusion: {in: [true, false] }, exclusion: { in: [nil]}
  validates :date_of_birth, presence: true, date_not_in_future: true
  validates :gender, presence: true, inclusion: {in: %w(Male Female) } # TODO: DRY list of allowed values
  validates :contact_number, presence: true
  validates :sponsored_by_another_org, inclusion: {in: [true, false] }, exclusion: { in: [nil]}
  validates :minor_siblings_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :original_address, presence: true
  validates :current_address, presence: true
  validates :orphan_status, presence: true
  validate :orphans_dob_within_gestation_of_fathers_death

  has_one :original_address, foreign_key: 'orphan_original_address_id', class_name: 'Address'
  has_one :current_address, foreign_key: 'orphan_current_address_id', class_name: 'Address'

  belongs_to :orphan_status

  accepts_nested_attributes_for :current_address, allow_destroy: true
  accepts_nested_attributes_for :original_address, allow_destroy: true

  def full_name
    [name, father_name].join(' ')
  end

  def orphans_dob_within_gestation_of_fathers_death
    # the longest recorded gestation period is 375 days the second longest 317 days
    # http://www.newhealthguide.org/Longest-Pregnancy.html
    min_gestation_offset = -317
    gestation_offset = days_between(father_date_of_death, date_of_birth)
    return unless gestation_offset
    if gestation_offset < min_gestation_offset
      errors.add(:date_of_birth, "date of birth must be within the gestation period of fathers death")
    end
  end
 
  private

  def days_between start_date, end_date
    begin 
      Date.parse(start_date.to_s) - Date.parse(end_date.to_s)
    rescue ArgumentError
      return false
    end
  end

end
