class Hq::OrphansController < HqController

  def show
    @orphan = Orphan.find(params[:id])
  end
end
