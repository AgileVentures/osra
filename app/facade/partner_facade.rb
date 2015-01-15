class PartnerFacade

  attr_reader :partner

  def build_partner(partner_params=nil)
    @partner = Partner.new(permitted_params(partner_params))
  end

  def load_partner(id)
    @partner = Partner.find(id)
  end

  def update_partner(id, partner_params)
    self.load_partner(id)
    @partner.attributes = permitted_params(partner_params)
  end

  def provinces
    @provinces ||= Province.all
  end

  def statuses
    @statuses ||= Status.all
  end

private

  def permitted_params(partner_params)
    if partner_params
      partner_params.permit(:name, :region, :contact_details, :province_id,
                            :status_id, :start_date)
    else
      {}
    end
  end
  
end
