ActiveAdmin.register Sponsorship do
  menu if: proc { false }
  actions :create
  belongs_to :sponsor

  member_action :inactivate, method: :put do
    sponsor = Sponsor.find(params[:sponsor_id])
    sponsorship = sponsor.sponsorships.find(params[:id])
    begin
      InactivateSponsorship.new(sponsorship: sponsorship,
                                end_date: params[:end_date]).call
      flash[:success] = 'Sponsorship link was successfully terminated.'
    rescue => error
      flash[:warning] = error.message
    ensure
      redirect_to admin_sponsor_path(sponsor)
    end
  end

  member_action :destroy, method: :delete do
    sponsor = Sponsor.find(params[:sponsor_id])
    sponsorship = sponsor.sponsorships.find(params[:id])
    begin
      DestroySponsorship.new(sponsorship).call
      flash[:success] = 'Sponsorship record was successfully destroyed.'
    rescue => error
      flash[:warning] = error.message
    ensure
      redirect_to admin_sponsor_path(sponsor)
    end
  end

  controller do
    def create
      sponsor = Sponsor.find(params[:sponsor_id])
      sponsorship = sponsor.sponsorships.build(orphan_id: params[:orphan_id],
                                               start_date: params[:sponsorship_start_date])
      begin
        CreateSponsorship.new(sponsorship).call
        flash[:success] = 'Sponsorship link was successfully created.'
        redirect_to admin_sponsor_path(sponsor)
      rescue => error
        flash[:warning] = error.message
        redirect_to new_sponsorship_path(sponsor, scope: 'eligible_for_sponsorship')
      end
    end
  end

  permit_params :orphan_id
end
