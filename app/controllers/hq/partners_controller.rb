class Hq::PartnersController < ApplicationController
  before_action :authenticate_admin_user!
  layout 'application'

  def index
    @partners= Partner.all
  end

  def show
    if not (@partner= Partner.find_by_id(params[:id]))
      flash[:error]= 'Cannot find Partner ' << params[:id].to_s
      redirect_to(action: 'index') and return
    end
    @fields= [:osra_num, :status_id, :start_date, :province_id, :region, :contact_details, :l_i_s_t_s, :created_at, :updated_at]
  end
end
