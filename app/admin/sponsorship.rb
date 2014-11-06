ActiveAdmin.register Sponsorship do
  menu if: proc { false }
  actions :create
  belongs_to :sponsor

  member_action :inactivate, method: :put do
    @sponsorship = Sponsorship.find(params[:id])
    @sponsor = Sponsor.find(params[:sponsor_id])
    @sponsorship.inactivate
    flash[:success] = 'Sponsorship link was successfully terminated'
    redirect_to admin_sponsor_path(@sponsor)
  end

  controller do
    def create
      @orphan = Orphan.find(params[:orphan_id])
      @sponsor = Sponsor.find(params[:sponsor_id])
      Sponsorship.create!(sponsor: @sponsor, orphan: @orphan)
      flash[:success] = 'Sponsorship link was successfully created'
      redirect_to admin_sponsor_path(@sponsor)
    end
  end

end

