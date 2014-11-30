class PartnersController < RailsController

  before_filter :get_title, :make_sort_sql

  def create
    partner= Partner.new @request_params[:partner].symbolize_keys
    if partner.save
      flash[:notice]= 'Partner was successfully created'
    else
      flash[:warning]= 'Partner was not created'
    end
    redirect_to admin_partner_path partner and return
  end

  def index
    @partners= Partner.all.order(@sort_sql)
    @action_item_links= [ ActionController::Base.helpers.link_to('New Partner', new_admin_partner_path) ]
  end

  def show
    @partner= Partner.find params[:id]
    @action_item_links= [ ActionController::Base.helpers.link_to('Edit Partner', edit_admin_partner_path(@partner)) ]
    if @partner.active?
      @action_item_links <<
      ActionController::Base.helpers.link_to('Upload Orphan List', upload_admin_partner_pending_orphan_lists_path(@partner))
    end
  end

  def new
    @partner= Partner.new
    get_form_options
  end

  def edit
    @partner= Partner.find params[:id]
    get_form_options
    @edit= true
  end

  def update
    @partner= Partner.find params[:id]
    if @partner.update @request_params[:partner].symbolize_keys
      flash[:notice]= 'Partner was successfully updated'
    else
      flash[:warning]= 'Partner was not updated'
    end
    redirect_to admin_partner_path(@partner) and return
  end

  private

  def get_form_options
    get_form_statuses
    get_form_provinces
  end

  def get_form_statuses
    @form_statuses= []
    Status.all.each do |status|
      @form_statuses << {name: status.name, id: status.id}.merge(
      if @partner.id && (@partner.status.name== status.name)
        {selected: true}
      else
        {selected: false}
      end)
    end
  end

  def get_form_provinces
    @form_provinces= []
    Province.all.each do |province|
      @form_provinces << {name: province.name, id: province.id}.merge(
      if @partner.id && (@partner.province.name== province.name)
        {selected: true}
      else
        {selected: false}
      end)
    end
  end

  def get_title
    super controller_name.singularize.titlecase
  end

end
