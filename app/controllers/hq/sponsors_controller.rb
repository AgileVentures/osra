class Hq::SponsorsController < HqController
  def index
    @sponsors = Sponsor.paginate(:page => params[:page])
  end

  def show
    load_sponsor
    load_active_and_inactive_sponsorships
  end

  def new
    build_sponsor
    load_associations
  end

  def create
    build_sponsor
    save_sponsor or re_render "new"
  end

  def edit
    load_sponsor
    load_associations
  end

  def update
    load_sponsor
    @sponsor.attributes= sponsor_params
    save_sponsor or re_render "edit"
  end

private

  def load_associations
    @statuses= Status.all
    @sponsor_types= SponsorType.all
    @organizations= Organization.all
    @branches= Branch.all
    @cities= Sponsor.all_cities.unshift(Sponsor::NEW_CITY_MENU_OPTION)
  end

  def build_sponsor
    @sponsor||= Sponsor.new
    @sponsor.attributes= sponsor_params if params[:sponsor]
  end

  def load_sponsor
    @sponsor= Sponsor.find(params[:id])
  end

  def load_active_and_inactive_sponsorships
    sponsorships = Sponsorship.where(sponsor: @sponsor)
    @sponsorships_active = sponsorships.select {|sp| sp.active == true}
    @sponsorships_inactive = sponsorships.select {|sp| sp.active == false}
  end

  def save_sponsor
    if @sponsor.save
      flash[:success]= "Sponsor successfuly created"
      redirect_to_new_or_saved_sponsor
    end
  end

  def redirect_to_new_or_saved_sponsor
    if params[:commit] == 'Create and Add Another'
      redirect_to new_hq_sponsor_path
    else
      redirect_to hq_sponsor_path(@sponsor)
    end
  end

  def re_render(view)
    load_associations
    render view
  end

  def sponsor_params
    params.require(:sponsor)
        .permit(:name, :address, :country, :email, :contact1, :contact2,
                :additional_info, :status_id, :start_date, :sponsor_type_id,
                :gender, :branch_id, :organization_id, :osra_num, :sequential_id,
                :requested_orphan_count, :agent_id, :city, :new_city_name, :payment_plan)
  end

end
