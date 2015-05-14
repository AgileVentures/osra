class Hq::AdminUsersController < HqController
  def index
    @admin_users = AdminUser.paginate(page: params[:page])
  end

  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = AdminUser.new
    @admin_user.attributes = admin_user_params
    if @admin_user.save
      flash[:success] = 'Admin User successfully created'
      redirect_to hq_admin_users_url
    else
      render 'new'
    end
  rescue ActiveRecord::RecordNotUnique
    # Devise causes a duplicate email address to result in this exception being raised within save
    @admin_user.errors.add(:email, 'is already taken')
    render 'new'
  end

private

  def admin_user_params
    params.require(:admin_user).permit(:email, :password, :password_confirmation)
  end

end
