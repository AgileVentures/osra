class Father < ActiveRecord::Base

  enum status: %i(dead alive)
  enum martyr_status: %i(not_martyr martyr)

  belongs_to :orphan

  validates :name, presence: true
  validates :status, presence: true
  validates :martyr_status, presence: true
  validates :orphan_id, presence: true, uniqueness: true
  validates :date_of_death, presence: true, date_not_in_future: true, if: :dead?

  # status (alive or dead) is taken as the basis for validations
  # of death-related attributes
  validate :not_martyr_if_alive
  validate :no_death_details_if_alive

  private

  def not_martyr_if_alive
    if alive? && martyr?
      errors[:martyr_status] << 'Father cannot be a martyr is he is alive.'
    end
  end

  def no_death_details_if_alive
    if alive? && death_details_present?
      errors[:status] << 'Cannot have details of death for living father.'
    end
  end

  def death_details_present?
    cause_of_death || place_of_death || date_of_death
  end
end
