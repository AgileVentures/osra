class Hq::SponsorsController < ApplicationController
  before_action :authenticate_admin_user!
  layout 'application'

  def index
    @sponsors= Sponsor.all
  end
end
