class Hq::PartnersController < HqController
  def index
    @partners = Partner.all.paginate(:page => params[:page])
  end

  def new
    @partner = Partner.new
    load_associations
  end

  def create
    build_partner
    save_partner or re_render 'new' and return # good standard practice to avoid DoubleRenderError
  end

  def show
    begin
      @partner= Partner.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      # Add warn method to log for easier tracking with logging software
      # (Papertrail in OSRA's case)
      # This should never happen - code error or user error?
      logger.warn 'A user tried to visit partner that does not exist'
      flash[:error] = 'Partner not found.'
      redirect_to_back_or_default
    end
  end

  def edit
    load_partner
    load_associations
  end

  def update
    load_partner
    build_partner
    save_partner or re_render 'edit' and return # good standard practice to avoid DoubleRenderError
  end

private
  def load_partner
    @partner = Partner.find(params[:id])
  end

  def load_associations
    @provinces = Province.all
    @statuses = Status.all
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

  def re_render(view)
    load_associations
    render view
  end

  def partner_params
    params.require(:partner)
          .permit(:name, :region, :contact_details,
                  :province_id, :status_id, :start_date)
  end

  # This would be in application_controller or a shared module
  def redirect_to_back_or_default(default = root_path)
    referer = request.env['HTTP_REFERER']
    if referer.present? && referer != request.env['REQUEST_URI']
      redirect_to :back
    else
      redirect_to default
    end
  end
end

