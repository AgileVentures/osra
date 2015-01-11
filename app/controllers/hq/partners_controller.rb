class Hq::PartnersController < ApplicationController
  before_action :authenticate_admin_user!,
                :new_partner_facade
  layout 'application'

  def index
    @partners = @partner_facade.load_all
  end

  def new
    @partner = @partner_facade.build
    load_associations
  end
  
  def create 
    @partner = @partner_facade.build(params[:partner])
    save_partner or re_render "new"
  end

  def show
    @partner = @partner_facade.load(params[:id])
  end

  def edit
    @partner = @partner_facade.load(params[:id])
    load_associations
  end

  def update
    @partner = @partner_facade.update(params[:id], params[:partner])
    save_partner or re_render 'edit'
  end

private

  def new_partner_facade
    @partner_facade = PartnerFacade.new
  end

  def load_associations
    @provinces = Province.all
    @statuses = Status.all
  end

  def save_partner
    if @partner.save
      flash[:success] = 'Partner successfuly saved'
      redirect_to hq_partner_url(@partner)
    end
  end

  def re_render(view)
    load_associations
    render view
  end

end
