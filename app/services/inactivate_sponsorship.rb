class InactivateSponsorship

  def initialize(sponsor:, sponsorship:, end_date:)
    @sponsorship = sponsorship
    @end_date = end_date
    @sponsor = sponsor
    @orphan = sponsorship.orphan
  end

  def call
    ActiveRecord::Base.transaction do
      inactivate_sponsorship!
      UpdateOrphanSponsorshipStatus.new(@orphan, 'Previously Sponsored').call
      UpdateSponsorSponsorshipData.new(@sponsor).call
    end
  end

  def inactivate_sponsorship!
    @sponsorship.update!(active: false, end_date: @end_date)
  end
end
