class Orphan < ActiveRecord::Base

  validate :validate_dates

  validates :name, presence: true
  validates :father_name, presence: true
  validates :father_is_martyr, inclusion: {in: [true, false] }
  validates :father_date_of_death, presence: true
  validates :mother_name, presence: true
  validates :mother_alive, inclusion: {in: [true, false] }
  validates :date_of_birth, presence: true
  validates :gender, presence: true
  validates :contact_number, presence: true
  validates :sponsored_by_another_org, inclusion: {in: [true, false] }
  validates :minor_siblings_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :original_address, presence: true
  validates :current_address, presence: true

  belongs_to :original_address, class_name: 'Address'
  belongs_to :current_address, class_name: 'Address'

  # to be replaced when PR #16 gets merged
  def validate_dates
    if !father_date_of_death.is_a?(Date)
      errors.add(:father_date_of_death,'should be a date')
    elsif father_date_of_death >= Date.today
      errors.add(:father_date_of_death,'cannot be in the future')
    end
    if !date_of_birth.is_a?(Date)
      errors.add(:date_of_birth,'should be a date')
    elsif date_of_birth >= Date.today
      errors.add(:date_of_birth,'cannot be in the future')
    end
  end

end
