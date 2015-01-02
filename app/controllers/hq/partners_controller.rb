class Hq::PartnersController < ApplicationController
  before_action :authenticate_admin_user!
  layout 'application'

  def index
    @partners= Partner.all
  end

  def show
    @partner= Partner.find(params[:id])
  end
end
