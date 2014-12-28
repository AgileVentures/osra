class Hq::PartnersController < HqController
  def index
    @partners= Partner.all
    #render 'partners/index'
  end
end
