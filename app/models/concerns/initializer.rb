module Initializer

  def default_status_to_under_revision
    self.status ||= Status.find_by_name 'Under Revision'
  end

  def default_start_date_to_today
    self.start_date ||= Date.current
  end

  def default_status_to_active
    self.orphan_status ||= OrphanStatus.find_by_name 'Active'
  end

  def default_sponsorship_status_to_unsponsored
    self.orphan_sponsorship_status ||= OrphanSponsorshipStatus.find_by_name 'Unsponsored'
  end
end
