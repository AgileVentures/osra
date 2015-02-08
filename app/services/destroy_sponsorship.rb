class DestroySponsorship

  def initialize(sponsor:, sponsorship:)
    @sponsor = sponsor
    @sponsorship = sponsorship
    @orphan = sponsorship.orphan
  end

  def call
    ActiveRecord::Base.transaction do
      destroy_sponsorship!
      resolve_status_and_update_orphan!
      UpdateSponsorSponsorshipData.new(@sponsor).call
    end
  end

  def resolve_status_and_update_orphan!
    status = ResolveOrphanSponsorshipStatus.new(@orphan).call
    UpdateOrphanSponsorshipStatus.new(@orphan, status).call
  end
end
