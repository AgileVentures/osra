class Hq::PartnersController < ApplicationController
  before_action :authenticate_admin_user!
  layout 'application'

  def index
    @partners= Partner.all
  end

  def new
    @partner = Partner.new
    load_associations
  end
  
  def create 
    build_partner
    unless save_partner
      load_associations
      render 'new'
    end
  end

  def show
    @partner= Partner.find(params[:id])
  end

  def edit
    load_partner
    load_associations
  end

  def update
    load_partner
    load_associations
    build_partner
    save_partner or render 'edit'
  end

private
  def load_partner
    @partner = Partner.find(params[:id])
  end

  def load_associations
    @provinces = Province.all
    @statuses = Status.all
  end

  def build_partner
    @partner ||= Partner.new
    @partner.attributes = partner_params
  end

  def save_partner
    if @partner.save
      flash[:success] = 'Partner successfuly saved'
      redirect_to hq_partner_url(@partner)
    end
  end

  def partner_params
    partner_params = params[:partner]
    if partner_params
      partner_params.permit(:name, :region, :contact_details, :province_id,
                            :status_id, :start_date)
    else
      {}
    end
  end

end
