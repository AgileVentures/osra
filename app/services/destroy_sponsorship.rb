class DestroySponsorship

  def initialize(sponsorship)
    @sponsorship = sponsorship
    @sponsor = sponsorship.sponsor
    @orphan = sponsorship.orphan
  end

  def call
    ActiveRecord::Base.transaction do
      destroy_sponsorship!
      resolve_status_and_update_orphan!
      update_and_save_sponsor!
    end
  end

  private

  attr_reader :sponsorship, :sponsor, :orphan

  def destroy_sponsorship!
    sponsorship.destroy!
  end

  def resolve_status_and_update_orphan!
    status = ResolveOrphanSponsorshipStatus.new(orphan).call
    UpdateOrphanSponsorshipStatus.new(orphan, status).call
    orphan.save!
  end

  def update_and_save_sponsor!
    UpdateSponsorSponsorshipData.new(sponsor).call
    sponsor.save!
  end
end
