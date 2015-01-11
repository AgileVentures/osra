class Hq::UsersController < ApplicationController
  before_action :authenticate_admin_user!
  layout 'application'

  def index
    @users = User.all
  end

end
