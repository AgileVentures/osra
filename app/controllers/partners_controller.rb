class PartnersController < RailsController
  def index
    @partners= Partner.all
    #render 'partners/index'
  end

end
