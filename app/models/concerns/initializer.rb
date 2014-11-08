module Initializer

  def default_status_to_active
    self.status ||= Status.find_by_name 'Active'
  end

  def default_start_date_to_today
    self.start_date ||= Date.current
  end

end
