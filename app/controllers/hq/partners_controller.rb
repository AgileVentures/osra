class Hq::PartnersController < HqController
  def index
    @partners = Partner.all.paginate(:page => params[:page])
  end

  def new
    @facade = PartnerFacade.new(Partner.new)
  end

  def create
    build_partner
    save_partner or render 'new'
  end

  def show
    @partner= Partner.find(params[:id])
  end

  def edit
    @facade = PartnerFacade.new(load_partner)
  end

  def update
    load_partner
    build_partner
    save_partner or render 'edit'
  end

private
  def load_partner
    @partner = Partner.find(params[:id])
  end

  def build_partner
    @partner ||= Partner.new
    @partner.attributes = partner_params
  end

  def save_partner
    if @partner.save
      flash[:success] = 'Partner successfuly saved'
      redirect_to hq_partner_url(@partner)
    end
  end

  def partner_params
    params.require(:partner)
          .permit(:name, :region, :contact_details,
                  :province_id, :status_id, :start_date)
  end

end

