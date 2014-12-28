class PartnersController < RailsController
  def index
	@partners = Partner.paginate(:page => params[:page], :per_page => (params[:per_page] || 5) )
  end

end
