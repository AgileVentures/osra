module DateValidator
  protected

  def validate_date_not_in_future
  	# clumsy hack
  	#debugger
   	if self.is_a?(Partner)
    	self.errors.add(:partnership_start_date, "is not valid (should not be in the future)") unless (self.partnership_start_date||Date.today) <= Date.today
    elsif self.is_a?(Sponsor)
    	self.errors.add(:sponsorship_start_date, "is not valid (should not be in the future)") unless (self.sponsorship_start_date||Date.today) <= Date.today
  	end
  end

end