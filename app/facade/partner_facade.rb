class PartnerFacade

  attr_reader :partner

  def build(partner_params=nil)
    @partner = Partner.new(permitted_params(partner_params))
  end

  def load(id)
    @partner = Partner.find(id)
  end

  def update(id, partner_params)
    self.load(id)
    @partner.attributes = permitted_params(partner_params)
    @partner
  end

  def load_all
    Partner.all
  end

  def save
    @partner.save
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
