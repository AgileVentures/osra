class Hq::OrphansController < HqController

  ADDRESS_DETAILS = [:id, :city, :province_id, :street, :neighborhood, :details]

  def index
    redirect_to(hq_orphans_path) if params["commit"]=="Clear Filters"

    @filters = filters_params
    @orphans = Orphan.filter(@filters).paginate(:page => params[:page])
    load_scope
  end

  def show
    load_orphan
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
    @orphan = Orphan.find(params[:id])
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
      redirect_to hq_orphan_url(@orphan)
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
                           .permit(:name_option, :name_value, :date_of_birth_at_from, :date_of_birth_at_until,
                                   :gender, :province_code, :priority, :sponsorship_status,
                                   :status, :orphan_list_partner_name, :father_given_name_option,
                                   :father_given_name_value, :family_name_option, :family_name_value,
                                   :father_is_martyr, :mother_alive, :health_status, :goes_to_school,
                                   :created_at_from, :created_at_until, :updated_at_from, :updated_at_until,
                                   original_address_attributes: ADDRESS_DETAILS)
                           .transform_values {|v| v=="" ? nil : v}
  end
end
