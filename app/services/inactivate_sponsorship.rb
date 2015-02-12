class InactivateSponsorship

  def initialize(sponsorship:, end_date:)
    @sponsorship = sponsorship
    @end_date = end_date
    @sponsor = sponsorship.sponsor
    @orphan = sponsorship.orphan
  end

  def call
    ActiveRecord::Base.transaction do
      inactivate_sponsorship!
      update_and_save_orphan!
      update_and_save_sponsor!
    end
  end

  private

  attr_reader :sponsorship, :end_date, :sponsor, :orphan

  def inactivate_sponsorship!
    sponsorship.update!(active: false, end_date: end_date)
  end

  def update_and_save_orphan!
    UpdateOrphanSponsorshipStatus.new(orphan, 'Previously Sponsored').call
    orphan.save!
  end

  def update_and_save_sponsor!
    UpdateSponsorSponsorshipData.new(sponsor).call
    sponsor.save!
  end
end
