class Hq::SponsorsController < HqController
  def index
    @sponsors= Sponsor.all
  end

  def show
    @sponsor = Sponsor.find(params[:id])
  end
end
