class Hq::SponsorsController < HqController
  def index
    @sponsors= Sponsor.all
  end
end
