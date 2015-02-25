class UpdateSponsorSponsorshipData

  def initialize(sponsor)
    @sponsor = sponsor
  end

  def call
    set_request_fulfilled!
    set_active_sponsorship_count!
  end

  def set_request_fulfilled!
    @sponsor.update!(request_fulfilled: is_request_fulfilled?)
  end

  def is_request_fulfilled?
    @sponsor.sponsorships.all_active.size >= @sponsor.requested_orphan_count
  end

  def set_active_sponsorship_count!
    @sponsor.update!(active_sponsorship_count:
                     @sponsor.sponsorships.all_active.size)
  end
end
