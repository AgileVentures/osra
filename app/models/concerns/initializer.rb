module Initializer

  def default_status_to_active
    if new_record?
      self.status ||= Status.find_by_name 'Active'
    end
  end

  def default_start_date_to_today
    self.start_date ||= Date.current
  end
end
