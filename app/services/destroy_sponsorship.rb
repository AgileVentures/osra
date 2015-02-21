class DestroySponsorship

  attr_reader :error_msg

  def initialize(sponsorship)
    @sponsorship = sponsorship
    @sponsor = sponsorship.sponsor
    @orphan = sponsorship.orphan
  end

  def call
    begin
      ActiveRecord::Base.transaction do
        destroy_sponsorship!
        resolve_status_and_update_orphan!
        update_and_save_sponsor!
      end
    rescue => error
      self.error_msg = error.message
      false
    end
  end

  private

  attr_reader :sponsorship, :sponsor, :orphan
  attr_writer :error_msg

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
