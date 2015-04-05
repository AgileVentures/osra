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
      .permit(:contact_number, :date_of_birth, :family_name, :father_deceased,
              :health_status, :schooling_status, :father_given_name,
              :father_is_martyr, :gender, :minor_siblings_count, :mother_alive,
              :mother_name, :name, :orphan_list_id, :orphan_sponsorship_status_id,
              :orphan_status_id, :priority, :sponsored_by_another_org, :sponsored_minor_siblings_count,
              :minor_siblings_count, :sponsored_minor_siblings_count,
              original_address: [:id, :city, :province_id, :street, :neighborhood],
              current_address: [:id, :city, :province_id, :street, :neighborhood])
  end
end
