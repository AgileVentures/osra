class Hq::OrphansController < HqController

# the solution for handling sorting basically follows the Railscast http://railscasts.com/episodes/228-sortable-table-columns
  helper_method :sort_column, :sort_direction

  ADDRESS_DETAILS = [:id, :city, :province_id, :street, :neighborhood, :details]

  def index
    if sort_column
      @orphans = Orphan.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page])
    else
      @orphans = Orphan.paginate(:page => params[:page])
    end
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

  def sort_column
    Orphan.column_names.include?(params[:sort_by]) ? params[:sort_by] : nil
  end
=begin
  def sort_column(param_column = params[:sort_by], table = Orphan, table_column = param_column)
    return nil if param_column.nil?
    p "in sort_column with " + param_column + ", " + table.to_s + ', ' + table_column
    if table_column.split('.').count == 1
      p "just checking this table's columns"
      table.column_names.include?(table_column) ? param_column : nil
    else
      p "checking association " + table_column
      table_column = table_column.sub(/^orphan./,'')
      return nil if table_column.split('.').count == 1
      table_name = table_column.slice(/[^.]*/)
      p "checking table " + table_name + " is an association"
      if table.reflections.keys.include?(table_name)
        p "got a match for this association - now calling sort_column recursively"
        sort_column(param_column, table.reflections[table_name].class_name.constantize, table_column.slice(table_name.length+1, table_column.length - table_name.length))
      else
        return nil
      end
    end
  end
=end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
