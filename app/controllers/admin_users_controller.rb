class AdminUsersController < ApplicationController
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
      redirect_to admin_users_url
    else
      render 'new'
    end
  rescue ActiveRecord::RecordNotUnique
    # Devise causes a duplicate email address to result in this exception being raised within save
    @admin_user.errors.add(:email, 'is already taken')
    render 'new'
  end

  def edit
    @admin_user = AdminUser.find(params[:id])
  end

  def update
    @admin_user = AdminUser.find(params[:id])
    # if just the admin user's email is changed (and password is untouched) then remove the password and
    # password confirmation from the params, so that Devise allows the update to happen
    if params[:admin_user][:password].blank?
      params[:admin_user].delete("password")
      params[:admin_user].delete("password_confirmation")
    end
    if @admin_user.update_attributes(admin_user_params)
      # if the password for a user is changed in this way then Devise automatically logs that user out 
      # (security feature in case the user has hacked in).
      # Hence if admin user changes his own pwd he will be logged out, so log him back in again automatically
      sign_in(@admin_user, :bypass => true) if @admin_user == current_admin_user
      flash[:success] = 'Admin User successfully saved'
      redirect_to admin_users_url
    else
      render 'edit'
    end
  end

  def destroy
    AdminUser.find(params[:id]).destroy
    flash[:success] = 'Admin User successfully deleted'
    redirect_to admin_users_path
  end

private

  def admin_user_params
    params.require(:admin_user).permit(:email, :password, :password_confirmation)
  end

end
