class CreateSponsorship

  def initialize(sponsorship)
    @sponsorship = sponsorship
    @sponsor = sponsorship.sponsor
    @orphan = sponsorship.orphan
  end

  def call
    ActiveRecord::Base.transaction do
      persist_sponsorship!
      update_and_save_orphan!
      update_and_save_sponsor!
    end
  end

  def persist_sponsorship!
    @sponsorship.save!
  end

  def update_and_save_orphan!
    UpdateOrphanSponsorshipStatus.new(@orphan, 'Sponsored').call
    @orphan.save!
  end

  def update_and_save_sponsor!
    UpdateSponsorSponsorshipData.new(@sponsor).call
    @sponsor.save!
  end
end
