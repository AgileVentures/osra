class Hq::AdminUsersController < HqController
  def index
    @admin_users = AdminUser.paginate(page: params[:page])
  end
end
