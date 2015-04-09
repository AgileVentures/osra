class Hq::OrphansController < HqController
  def index
    @orphans = Orphan.paginate(:page => params[:page])
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

  def load_orphan
    @orphan = Orphan.find(params[:id])
  end

  def load_associations
    @orphan_statuses = OrphanStatus.all
    @orphan_sponsorship_statuses = OrphanSponsorshipStatus.all
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
              :name, :father_is_martyr, :father_occupation, :father_place_of_death,
              :father_cause_of_death, :father_date_of_death, :mother_name, :mother_alive,
              :date_of_birth, :gender, :health_status, :schooling_status, :goes_to_school,
              :guardian_name, :guardian_relationship, :guardian_id_num, :contact_number,	
              :alt_contact_number, :sponsored_by_another_org, :another_org_sponsorship_details,
              :minor_siblings_count, :sponsored_minor_siblings_count, :comments, :created_at,
              :updated_at, :orphan_status_id, :orphan_sponsorship_status_id, :priority,
              :sequential_id, :osra_num, :orphan_list_id, :province_code, 
              :father_given_name, :family_name, :father_deceased,
              original_address: [:id, :city, :province_id, :street, :neighborhood, :details],
              current_address: [:id, :city, :province_id, :street, :neighborhood, :details]
            )
  end
end
