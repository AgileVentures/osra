class ResolveOrphanSponsorshipStatus

  def initialize(orphan)
    @orphan = orphan
  end

  def call
    if orphan.sponsorships.empty?
      'unsponsored'
    elsif orphan.sponsorships.all_active.empty?
      'previously_sponsored'
    elsif orphan.sponsorships.all_active.present?
      'sponsored'
    end
  end

  private

  attr_reader :orphan
end
