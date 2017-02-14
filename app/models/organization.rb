class Organization < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true, 
            numericality: {only_integer: true, greater_than_or_equal_to: 50,
                           less_than_or_equal_to: 99,
                           message: "must be a whole number between 50 and 99" }
  validates :name, presence: true, uniqueness: true, case_sensitive: false
end
