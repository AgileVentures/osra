module DateValidator
  protected

  def validate_date_not_in_future
    self.errors.add(:partnership_start_date, "is not valid (should not be in the future)") unless (self.partnership_start_date||Date.today) <= Date.today
  end

end