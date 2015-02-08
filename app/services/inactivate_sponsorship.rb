class InactivateSponsorship

  def initialize(sponsor:, sponsorship:, end_date:)
    @sponsorship = sponsorship
    @end_date = end_date
    @sponsor = sponsor
  end

  def call
    ActiveRecord::Base.transaction do
      inactivate_sponsorship!
      update_orphan!
      update_sponsor!
    end
  end

  def inactivate_sponsorship!
    @sponsorship.update!(active: false, end_date: @end_date)
  end

  def update_orphan!
    new_status = OrphanSponsorshipStatus.find_by_name 'Previously Sponsored'
    @sponsorship.orphan.update!(orphan_sponsorship_status: new_status)
  end

  def update_sponsor!
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
