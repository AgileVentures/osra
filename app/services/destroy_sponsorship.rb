class DestroySponsorship

  def initialize(sponsorship)
    @sponsorship = sponsorship
    @sponsor = sponsorship.sponsor
    @orphan = sponsorship.orphan
  end

  def call
    ActiveRecord::Base.transaction do
      destroy_sponsorship! and
        resolve_status_and_update_orphan! and
        UpdateSponsorSponsorshipData.new(@sponsor).call
    end
  end

  def destroy_sponsorship!
    @sponsorship.destroy!
  end

  def resolve_status_and_update_orphan!
    status = ResolveOrphanSponsorshipStatus.new(@orphan).call
    UpdateOrphanSponsorshipStatus.new(@orphan, status).call
  end
end
