class UpdateOrphanSponsorshipStatus

  def initialize(orphan, status_name)
    @orphan = orphan
    @status_name = status_name
  end

  def call
    status = OrphanSponsorshipStatus.find_by_name @status_name
    @orphan.orphan_sponsorship_status = status
  end
end
