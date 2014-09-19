module Initializer

  def default_status_to_under_revision
    self.status ||= Status.find_by_name 'Under Revision'
  end

  def default_start_date_to_today
    self.start_date ||= Date.current
  end
end
