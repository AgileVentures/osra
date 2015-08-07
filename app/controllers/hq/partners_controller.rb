class Hq::PartnersController < HqController

  def index
    @current_sort_column = params[:sort_column] || :name #params permit
    @current_sort_column = @current_sort_column.to_sym
    @current_sort_direction = sort_direction_params #params permit

    @partners = Partner
      .includes(params[:sort_columns_included_resource])
      .order(@current_sort_column.to_s + " " +  @current_sort_direction.to_s)
      .paginate(:page => params[:page])
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

  # #validates model relation
  # def sort_include
  #   return nil if params[:includ].nil?
  #   partner_associations = Partner.reflect_on_all_associations(:belongs_to).map(&:name)
  #   partner_associations.include?(params[:includ].to_sym) ? params[:includ] : nil
  # end

  # #validates sorting column
  # def sort_column
  #   if params[:sort] && params[:sort].include?(".")                 #if "provinces.name"
  #     associated_model = params[:sort].split(".")[0].singularize    #-> "province"
  #     associated_model_field = params[:sort].split(".")[1]          #-> "name"
  #     partner_associations = Partner.reflect_on_all_associations(:belongs_to).map(&:name)

  #     return "name" unless partner_associations.include?(associated_model.to_sym) #check that Partner has_one "province"
  #     return "name" unless eval(associated_model.capitalize).
  #                     column_names.include? associated_model_field  #check that Province has column "name"
  #   else                                                            #if "start_date"
  #     return "name" unless Partner.column_names.include?(params[:sort])
  #   end

  #   return params[:sort]
  # end

  #validates sorting direction
  def sort_direction_params
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : "asc"
  end

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
      redirect_to hq_partner_url(@partner)
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

end

