class SponsorsController < ApplicationController
  def index
    redirect_to(sponsors_path) and return if params["commit"]=="Clear Filters"

    @current_sort_column = valid_sort_column
    @current_sort_direction = valid_sort_direction

    @filters = filters_params
    @sort_by = sort_by_params
    @sortable_by_column = true

    @sponsors_before_paginate = Sponsor
      .includes(:status, :sponsor_type)
      .filter(@filters)
      .order(@current_sort_column.to_s + " " +  @current_sort_direction.to_s)
    @sponsors = @sponsors_before_paginate.paginate(:page => params[:page])

    load_scope

    respond_to do |format|
      format.html
      format.csv { send_data Sponsor.to_csv(@sponsors_before_paginate), filename: "sponsors-#{Date.today}.csv" }
    end
  end

  def show
    load_sponsor
    load_active_and_inactive_sponsorships
  end

  def new
    build_sponsor
    load_associations
  end

  def create
    build_sponsor
    save_sponsor or re_render "new"
  end

  def edit
    load_sponsor
    load_associations
  end

  def update
    load_sponsor
    @sponsor.attributes= sponsor_params
    save_sponsor or re_render "edit"
  end

private

  def load_associations
    @statuses= Status.all
    @sponsor_types= SponsorType.all
    @organizations= Organization.all
    @branches= Branch.all
    @cities= Sponsor.all_cities.unshift(Sponsor::NEW_CITY_MENU_OPTION)
  end

  def build_sponsor
    @sponsor||= Sponsor.new
    @sponsor.attributes= sponsor_params if params[:sponsor]
  end

  def load_sponsor
    @sponsor= Sponsor.find(params[:id])
  end

  def load_active_and_inactive_sponsorships
    sponsorships = Sponsorship.where(sponsor: @sponsor)
    @sponsorships_active = sponsorships.select {|sp| sp.active == true}
    @sponsorships_inactive = sponsorships.select {|sp| sp.active == false}
  end

  def save_sponsor
    if @sponsor.save
      flash[:success]= "Sponsor successfuly saved"
      redirect_to_new_or_saved_sponsor
    end
  end

  def redirect_to_new_or_saved_sponsor
    if params[:commit] == 'Create and Add Another'
      redirect_to new_sponsor_path
    else
      redirect_to sponsor_path(@sponsor)
    end
  end

  def re_render(view)
    load_associations
    render view
  end

  def sponsor_params
    params.require(:sponsor)
        .permit(:name, :address, :country, :email, :contact1, :contact2,
                :additional_info, :status_id, :start_date, :sponsor_type_id,
                :gender, :branch_id, :organization_id, :osra_num, :sequential_id,
                :requested_orphan_count, :agent_id, :city, :new_city_name, :payment_plan)
  end

  def filters_params
    params[:filters] ||= {}
    permited_filters = params[:filters]
          .permit(:name_option, :name_value, :gender, :branch_id, :organization_id, :status_id,
           :sponsor_type_id, :agent_id, :city, :country, :created_at_from, :created_at_until,
           :updated_at_from, :updated_at_until, :start_date_from, :start_date_until,
           :request_fulfilled, :active_sponsorship_count_option, :active_sponsorship_count_value)
          .transform_values {|v| v=="" ? nil : v}
  end

  def sort_by_params
    params[:sort_by] ||= {}
    permited_filters = params[:sort_by].permit(:column, :direction)
      .transform_values {|v| v=="" ? nil : v}
  end

  def valid_sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : "asc"
  end

  def valid_sort_column
    %w[osra_num name start_date request_fulfilled country].include?(params[:sort_column]) ? params[:sort_column].to_sym : :name
  end

  def load_scope
    @sponsors_count = Sponsor.count
  end

end
