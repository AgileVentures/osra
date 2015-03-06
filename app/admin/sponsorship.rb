ActiveAdmin.register Sponsorship do
  menu if: proc { false }
  actions :create, :destroy
  belongs_to :sponsor

  member_action :inactivate, method: :put do
  end

  controller do
    def create
      sponsor = Sponsor.find(params[:sponsor_id])
      sponsorship = sponsor.sponsorships.build(orphan_id: params[:orphan_id],
                                               start_date: params[:sponsorship_start_date])

      @sponsorship_creator = CreateSponsorship.new(sponsorship)

      create_sponsorship_for(sponsor) or
        redirect_back_to_new_sponsorship_for(sponsor)
    end

    def inactivate
      sponsor = Sponsor.find(params[:sponsor_id])
      sponsorship = sponsor.sponsorships.find(params[:id])

      @sponsorship_inactivator = InactivateSponsorship.new(sponsorship: sponsorship,
                                                           end_date: params[:end_date])

      inactivate_sponsorship and redirect_to admin_sponsor_path(sponsor)
    end

    def destroy
      sponsor = Sponsor.find(params[:sponsor_id])
      sponsorship = sponsor.sponsorships.find(params[:id])

      @sponsorship_destructor = DestroySponsorship.new(sponsorship)

      destroy_sponsorship and
        redirect_to admin_sponsor_path(sponsor)
    end

    private

    def create_sponsorship_for(sponsor)
      if @sponsorship_creator.call
        flash[:success] = 'Sponsorship link was successfully created.'
        redirect_to admin_sponsor_path(sponsor)
      end
    end

    def redirect_back_to_new_sponsorship_for(sponsor)
      flash[:warning] = @sponsorship_creator.error_msg
      redirect_to new_sponsorship_path(sponsor, scope: 'eligible_for_sponsorship')
    end

    def inactivate_sponsorship
      if @sponsorship_inactivator.call
        flash[:success] = 'Sponsorship link was successfully terminated.'
      else
        flash[:warning] = @sponsorship_inactivator.error_msg
      end
    end

    def destroy_sponsorship
      if @sponsorship_destructor.call
        flash[:success] = 'Sponsorship record was successfully destroyed.'
      else
        flash[:warning] = @sponsorship_destructor.error_msg
      end
    end
  end

  permit_params :orphan_id
end
