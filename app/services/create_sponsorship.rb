class CreateSponsorship

  attr_reader :error_msg

  def initialize(sponsorship)
    @sponsorship = sponsorship
    @sponsor = sponsorship.sponsor
    @orphan = sponsorship.orphan
  end

  def call
    begin
      ActiveRecord::Base.transaction do
        persist_sponsorship!
        update_and_save_orphan!
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

  def persist_sponsorship!
    sponsorship.save!
  end

  def update_and_save_orphan!
    UpdateOrphanSponsorshipStatus.new(orphan, 'Sponsored').call
    orphan.save!
  end

  def update_and_save_sponsor!
    UpdateSponsorSponsorshipData.new(sponsor).call
    sponsor.save!
  end
end
