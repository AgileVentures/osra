module SponsorshipTotalsHelper

  def total_active_sponsorships
    Sponsorship.all_active.size
  end

  def total_requested_sponsorships
    Sponsor.all_active.pluck(:requested_orphan_count).sum
  end
end
