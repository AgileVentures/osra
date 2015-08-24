class Hq::PendingOrphanListsController < HqController

  def upload
    get_partner

    unless @partner.active?
      flash[:error] = 'Partner is not Active. Orphan List cannot be uploaded.'
      redirect_to hq_partner_path(@partner)
      return
    end
  end

private

  def get_partner
    @partner = Partner.find(params[:partner_id])
  end

end
