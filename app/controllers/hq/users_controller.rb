class Hq::UsersController < HqController
  def index
    @users = User.all
  end
end
