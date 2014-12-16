class PartnersController < RailsController
  def index
	@partners = Partner.all.paginate(:page => params[:page], :per_page => 5)
  end

end
