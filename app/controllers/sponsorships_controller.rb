class SponsorshipsController < ApplicationController

  def create
    sponsor = Sponsor.find(params[:sponsor_id])
    orphan = Orphan.find(params[:orphan_id])
    sponsorship = sponsor.sponsorships.build(orphan_id: params[:orphan_id],
                                             start_date: params[:sponsorship_start_date])

    @sponsorship_creator = CreateSponsorship.new(sponsorship)

    create_sponsorship_for(sponsor, orphan) or
        redirect_back_to_new_sponsorship_for(sponsor)
  end

  def inactivate
    sponsorship = Sponsorship.find(params[:id])
    sponsor = sponsorship.sponsor

    @sponsorship_inactivator = InactivateSponsorship.new(sponsorship: sponsorship,
                                                         end_date: params[:sponsorship][:end_date])
    inactivate_sponsorship and redirect_to sponsor_path(sponsor)
  end

  def destroy
    sponsorship = Sponsorship.find(params[:id])
    sponsor = sponsorship.sponsor

    @sponsorship_destructor = DestroySponsorship.new(sponsorship)

    destroy_sponsorship and redirect_to sponsor_path(sponsor)
  end

  private

  def create_sponsorship_for(sponsor, orphan)
    if @sponsorship_creator.call
      if sponsor.request_fulfilled
        flash[:success] = 'Sponsorship link was successfully created.'
        redirect_to sponsor_path(sponsor)
      else
        flash[:success] = "Sponsorship link was successfully created for #{orphan.full_name}"
        redirect_to new_sponsorship_path(sponsor, scope: 'eligible_for_sponsorship')
      end
    end
  end

  def redirect_back_to_new_sponsorship_for(sponsor)
    flash[:error] = @sponsorship_creator.error_msg
    redirect_to new_sponsorship_path(sponsor, scope: 'eligible_for_sponsorship')
  end

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
