class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user= User.find params[:id]
    @inactive_sponsors = @user.inactive_sponsors.paginate(:page => params[:inactive_sponsor])
    @active_sponsors = @user.active_sponsors.paginate(:page => params[:active_sponsor])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'User successfully saved'
      redirect_to user_url(@user)
    else
      render 'edit'
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.attributes = user_params
    if @user.save
      flash[:success] = 'User successfully created'
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end

private

  def user_params
    params.require(:user).permit(:user_name, :email)
  end

end
