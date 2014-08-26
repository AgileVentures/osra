module DateValidator
  protected

  def validate_date_not_in_future
    self.errors.add(:start_date, 'is not valid (should not be in the future)') unless self.start_date <= Date.current
    # if self.is_a?(Partner)
     #  self.errors.add(:partnership_start_date, "is not valid (should not be in the future)") unless (self.partnership_start_date||Date.current) <= Date.current
    # elsif self.is_a?(Sponsor)
    	# self.errors.add(:sponsorship_start_date, "is not valid (should not be in the future)") unless (self.sponsorship_start_date||Date.current) <= Date.current
  	# end
  end

end