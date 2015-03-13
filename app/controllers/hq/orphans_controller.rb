class Hq::OrphansController < HqController

  def show
    @orphan = Orphan.find(params[:id])
  end

  def index
    @orphans = Orphan.paginate(:page => params[:page])
  end

  def create
  end
end
