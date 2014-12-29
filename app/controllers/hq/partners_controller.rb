class Hq::PartnersController < ApplicationController
  before_filter :authenticate_admin_user!
  layout 'application'

  def index
    @partners= Partner.all
  end
end
