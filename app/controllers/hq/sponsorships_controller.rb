class Hq::SponsorshipsController < HqController

  def inactivate
    sponsorship = Sponsorship.find(params[:id])
    if sponsorship.inactivate params[:sponsorship][:end_date]
      flash[:success] = 'Sponsorship link was successfully terminated'
    else
      flash[:error] = sponsorship.errors.full_messages || 'Sponsorship not terminated'
    end
    redirect_to hq_sponsor_path(sponsorship.sponsor_id)
  end

  def destroy
    sponsorship = Sponsorship.find(params[:id])
    if sponsorship.destroy
      flash[:success] = 'Sponsorship was successfully deleted'
    else
      flash[:error] = 'Sponsorship not deleted'
    end
    redirect_to hq_sponsor_path(sponsorship.sponsor_id)
  end

end