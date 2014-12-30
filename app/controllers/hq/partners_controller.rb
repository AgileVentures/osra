class Hq::PartnersController < ApplicationController
  before_action :authenticate_admin_user!
  layout 'application'

  def index
    @partners= Partner.all
  end
end
