class ResolveOrphanSponsorshipStatus

  def initialize(orphan)
    @orphan = orphan
  end

  def call
    if @orphan.sponsorships.empty?
      'Unsponsored'
    elsif @orphan.sponsorships.all_active.empty?
      'Previously Sponsored'
    elsif @orphan.sponsorships.all_active.present?
      'Sponsored'
    end
  end
end
