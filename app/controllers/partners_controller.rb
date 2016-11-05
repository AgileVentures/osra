class PartnersController < ApplicationController

  def index
    @current_sort_column = valid_sort_column
    @current_sort_direction = valid_sort_direction

    @partners = Partner.
      includes(:status, :province).
      order(@current_sort_column.to_s + " " +  @current_sort_direction.to_s).
      paginate(:page => params[:page])
  end

  def new
    @partner = Partner.new
    load_associations
  end

  def create
    build_partner
    save_partner or re_render 'new'
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
    build_partner
    save_partner or re_render 'edit'
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
      redirect_to partner_url(@partner)
    end
  end

  def re_render(view)
    load_associations
    render view
  end

  def partner_params
    params.require(:partner)
          .permit(:name, :region, :contact_details,
                  :province_id, :status_id, :start_date)
  end

  def valid_sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : "asc"
  end

  def valid_sort_column
    %w[
      osra_num name start_date provinces.name
    ].include?(params[:sort_column]) ? params[:sort_column].to_sym : :name
  end
end

