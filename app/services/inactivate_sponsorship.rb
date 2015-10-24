class InactivateSponsorship

  attr_reader :error_msg

  def initialize(sponsorship:, end_date:)
    @sponsorship = sponsorship
    @end_date = end_date
    @sponsor = sponsorship.sponsor
    @orphan = sponsorship.orphan
  end

  def call
    begin
      ActiveRecord::Base.transaction do
        inactivate_sponsorship!
        update_and_save_orphan!
        update_and_save_sponsor!
      end
    rescue => error
      self.error_msg = error.message
      false
    end
  end

  private

  attr_reader :sponsorship, :end_date, :sponsor, :orphan
  attr_writer :error_msg

  def inactivate_sponsorship!
    sponsorship.update!(active: false, end_date: end_date)
  end

  def update_and_save_orphan!
    UpdateOrphanSponsorshipStatus.new(orphan, 'previously_sponsored').call
    orphan.save!
  end

  def update_and_save_sponsor!
    UpdateSponsorSponsorshipData.new(sponsor).call
    sponsor.save!
  end
end
