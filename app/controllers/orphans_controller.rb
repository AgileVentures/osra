class OrphansController < ApplicationController

  ADDRESS_DETAILS = [:id, :city, :province_id, :street, :neighborhood, :details]

  def index
    redirect_to(orphans_path) and return if params["commit"]=="Clear Filters"

    @current_sort_column = valid_sort_column
    @current_sort_direction = valid_sort_direction

    @filters = filters_params
    @orphans_before_paginate = Orphan.with_filter_fields.filter(@filters).
      order(@current_sort_column.to_s + " " +  @current_sort_direction.to_s)
    @orphans = @orphans_before_paginate.paginate(:page => params[:page])

    load_scope

    respond_to do |format|
      format.html
      format.csv { send_data Orphan.to_csv(@orphans_before_paginate), filename: "orphans-#{Date.today}.csv" }
    end
  end

  def show
    load_orphan
    @sponsor = @orphan.current_sponsor
  end

  def edit
    load_orphan
    load_associations
  end

  def update
    load_orphan
    @orphan.attributes = orphan_params if params[:orphan]
    save_orphan or re_render 'edit'
  end

private

  def load_scope
    @orphans_count = Orphan.count
    @orphans_sort_by_eligibility_count = Orphan.sort_by_eligibility.count
    if params[:scope] == 'eligible_for_sponsorship'
      @orphans = @orphans.sort_by_eligibility
      @eligible_for_sponsorship = true
    end
    if params[:sponsor_id]
      @sponsor = Sponsor.find(params[:sponsor_id])
    end
  end

  def load_orphan
    @orphan = Orphan.includes([:current_sponsorship, :current_sponsor]).find(params[:id])
  end

  def load_associations
    @statuses = Orphan.statuses.keys.map { |k| [k.humanize, k] }
    @sponsorship_statuses = Orphan.sponsorship_statuses.keys.map do |k|
      [k.humanize, k]
    end
    @provinces = Province.all
  end

  def save_orphan
    if @orphan.save
      flash[:success] = 'Orphan successfuly saved'
      redirect_to orphan_url(@orphan)
    end
  end

  def re_render(view)
    load_associations
    render view
  end

  def orphan_params
    params.require(:orphan)
      .permit(
              :name, :father_is_martyr, :father_occupation,
              :father_place_of_death, :father_cause_of_death,
              :father_date_of_death, :mother_name, :mother_alive,
              :date_of_birth, :gender, :health_status, :schooling_status,
              :goes_to_school, :guardian_name, :guardian_relationship,
              :guardian_id_num, :contact_number, :alt_contact_number,
              :sponsored_by_another_org, :another_org_sponsorship_details,
              :minor_siblings_count, :sponsored_minor_siblings_count, :comments,
              :status, :priority, :sequential_id, :osra_num, :orphan_list_id,
              :province_code, :father_given_name, :family_name,
              :father_deceased, original_address_attributes: ADDRESS_DETAILS,
              current_address_attributes: ADDRESS_DETAILS
            )
  end

  def filters_params
    params[:filters] ||= {}
    permited_filters = params[:filters]
                           .permit(:name_option, :name_value, :date_of_birth_from, :date_of_birth_until,
                                   :gender, :province_code, :original_address_city, :priority,
                                   :sponsorship_status, :status, :orphan_list_partner_name,
                                   :father_given_name_option, :father_given_name_value,
                                   :family_name_option, :family_name_value, :father_is_martyr,
                                   :mother_alive, :health_status, :goes_to_school, :created_at_from,
                                   :created_at_until, :updated_at_from, :updated_at_until)
                           .transform_values {|v| v=="" ? nil : v}
  end

  def valid_sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : "asc"
  end

  def valid_sort_column
    %w[
      osra_num orphans.name father_given_name date_of_birth gender
      province_name partner_name father_is_martyr father_deceased
      mother_alive priority status sponsorship_status sponsor_name
    ].include?(params[:sort_column]) ? params[:sort_column].to_sym : :"orphans.name"
  end

  def valid_sort_columns_included_resource
    %w[
      original_address orphan_list
    ].include?(params[:sort_columns_included_resource]) ? params[:sort_columns_included_resource].to_sym : nil
  end

end
