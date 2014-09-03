class Branch < ActiveRecord::Base

  validates :name, presence: true
  validates :code, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 99}

end
