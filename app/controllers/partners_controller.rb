class PartnersController < RailsController

  before_filter :get_title

  def new
    @partner= Partner.new
  end

  def create
    partner= Partner.new @request_params[:partner].symbolize_keys
    partner.save!
    redirect_to admin_partner_path partner
  end

  def index
    @partners= Partner.all
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

  def edit
    @partner= Partner.find params[:id]
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

  #def destroy
  #end

  private

  def get_title
    super 'Partner'
  end

end
