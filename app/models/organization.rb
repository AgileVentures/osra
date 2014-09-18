class Organization < ActiveRecord::Base
  include Initializer
  after_initialize :default_status_to_under_revision, :default_start_date_to_today

  validates :code, presence: true, uniqueness: true, 
            numericality: {only_integer: true, greater_than_or_equal_to: 0,
                           less_than_or_equal_to: 99,
                           message: "must be a whole number between 0 and 99" }
  validates :name, presence: true, uniqueness: true
  validates :country, presence: true
  validates :status_id, presence: true
  validates :start_date, date_not_in_future: true

  belongs_to :status
end
