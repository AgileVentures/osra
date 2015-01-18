class Hq::PartnersController < ApplicationController
  before_action :authenticate_admin_user!,
                :new_partner_facade
  layout 'application'

  def index
    @partners = Partner.all
  end

  def new
    @partner_facade.build_partner
  end
  
  def create 
    @partner_facade.build_partner(params[:partner])
    save_partner or render :new
  end

  def show
    @partner_facade.load_partner(params[:id])
  end

  def edit
    @partner_facade.load_partner(params[:id])
  end

  def update
    @partner_facade.update_partner(params[:id], params[:partner])
    save_partner or render :edit
  end

private

  def new_partner_facade
    @partner_facade = PartnerFacade.new
  end

  def save_partner
    if @partner_facade.partner.save
      flash[:success] = 'Partner successfuly saved'
      redirect_to hq_partner_url(@partner_facade.partner)
    end
  end
end
