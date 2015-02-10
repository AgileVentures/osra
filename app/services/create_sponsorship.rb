class CreateSponsorship

  def initialize(sponsorship)
    @sponsorship = sponsorship
    @sponsor = sponsorship.sponsor
    @orphan = sponsorship.orphan
  end

  def call
    ActiveRecord::Base.transaction do
      save_sponsorship! and
        UpdateOrphanSponsorshipStatus.new(@orphan, 'Sponsored').call and
        UpdateSponsorSponsorshipData.new(@sponsor).call
    end
  end

  def save_sponsorship!
    @sponsorship.save!
  end
end
