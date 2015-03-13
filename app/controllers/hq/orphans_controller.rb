class Hq::OrphansController < HqController
  def index
    @orphans = Orphan.paginate(:page => params[:page])
  end

  def create
    @orphan ||= Orphan.new
    @orphan.attributes = orphan_params
    save_orphan or re_render 'new'
  end

  def edit
    load_orphan
    load_associations
  end

  def update
    load_orphan
    build_orphan
    save_orphan or re_render 'edit'
  end

private
  def load_orphan
    @orphan = Orphan.find(params[:id])
  end

  def orphan_params
    params.require(:orphan)
      .permit(:contact_number, :date_of_birth, :family_name, :father_alive,
              :father_given_name, :father_is_martyr, :gender, :minor_siblings_count,
              :mother_alive, :mother_name, :name, :orphan_list_id, :orphan_sponsorship_status_id,
              :orphan_status_id, :priority, :sponsored_by_another_org, :sponsored_minor_siblings_count, 
              :minor_siblings_count, :sponsored_minor_siblings_count,
              :original_address, :current_address)
  end

  def build_orphan
    @orphan ||= Orphan.new
    @orphan.attributes = orphan_params
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
end
