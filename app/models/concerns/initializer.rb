module Initializer

  def set_status
    self.status ||= Status.find_by_name 'Under Revision'
  end

  def set_start_date
    self.start_date ||= Date.current
  end
end
