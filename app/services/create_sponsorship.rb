class CreateSponsorship

  def initialize(sponsor:, sponsorship:)
    @sponsor = sponsor
    @sponsorship = sponsorship
    @orphan = sponsorship.orphan
  end

  def call
    ActiveRecord::Base.transaction do
      save_sponsorship!
      UpdateOrphanSponsorshipStatus.new(@orphan, 'Sponsored').call
      UpdateSponsorSponsorshipData.new(@sponsor).call
    end
  end

  def save_sponsorship!
    @sponsorship.save!
  end
end
