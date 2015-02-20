class Hq::OrphansController < HqController
  def index
    @orphans = Orphan.paginate(:page => params[:page])
  end

  # def new
  # end

  def create
  end

  # def show
  # end
  #
  # def edit
  # end
  #
  # def update
  # end
end
