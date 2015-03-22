class Hq::SponsorshipsController < HqController

  def inactivate
    sponsorship = Sponsorship.find(params[:id])
    sponsor = sponsorship.sponsor

    @sponsorship_inactivator = InactivateSponsorship.new(sponsorship: sponsorship,
                                                         end_date: params[:sponsorship][:end_date])
    inactivate_sponsorship and redirect_to hq_sponsor_path(sponsor)
  end

  def destroy
    sponsorship = Sponsorship.find(params[:id])
    sponsor = sponsorship.sponsor

    @sponsorship_destructor = DestroySponsorship.new(sponsorship)

    destroy_sponsorship and redirect_to hq_sponsor_path(sponsor)
  end

  private

  def inactivate_sponsorship
    if @sponsorship_inactivator.call
      flash[:success] = 'Sponsorship link was successfully terminated.'
    else
      flash[:error] = @sponsorship_inactivator.error_msg
    end
  end

  def destroy_sponsorship
    if @sponsorship_destructor.call
      flash[:success] = 'Sponsorship record was successfully destroyed.'
    else
      flash[:error] = @sponsorship_destructor.error_msg
    end
  end

end