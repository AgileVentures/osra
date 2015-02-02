ActiveAdmin.register Sponsorship do
  menu if: proc { false }
  actions :create
  belongs_to :sponsor

  member_action :inactivate, method: :put do
    sponsor = Sponsor.find(params[:sponsor_id])
    # enforce sponsor/sponsorship match
    sponsorship = sponsor.sponsorships.find(params[:id])
    if sponsorship.inactivate params[:end_date]
      flash[:success] = 'Sponsorship link was successfully terminated'
    else
      flash[:warning] = sponsorship.errors.full_messages || 'Sponsorship not terminated'
    end
    redirect_to admin_sponsor_path(sponsor)
  end

  controller do
    def create
      @sponsor = Sponsor.find(params[:sponsor_id])
      sponsorship= Sponsorship.new(sponsor: @sponsor, orphan_id: params[:orphan_id],
                                      start_date: params[:sponsorship_start_date].to_s )
      if sponsorship.save
        flash[:success] = 'Sponsorship link was successfully created.'
        redirect_to admin_sponsor_path(@sponsor.id)
      else
        flash[:warning]= sponsorship.errors.full_messages || 'Sponsorship not created'
        redirect_to new_sponsorship_path(@sponsor.id, scope: 'eligible_for_sponsorship')
      end
    end
  end

  permit_params :orphan_id
end
