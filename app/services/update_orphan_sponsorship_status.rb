class UpdateOrphanSponsorshipStatus

  def initialize(orphan, status)
    @orphan = orphan
    @status = status
  end

  def call
    orphan.sponsorship_status = status
  end

  private

  attr_reader :orphan, :status
end
