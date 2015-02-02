class PartnerFacade

  attr_reader :partner

  def initialize(partner)
    @partner = partner
  end

  def provinces
    Province.all
  end

  def statuses
    Status.all
  end
end
