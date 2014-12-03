class PartnersController < RailsController

  before_filter :get_title, :make_sort_sql

  def create
    #TODO: investigate whether the next line might introduce a symbol overflow vulnerbility (param[:foo].to_sym)
    partner= Partner.new @request_params[:partner].symbolize_keys
    if partner.save
      flash[:notice]= 'Partner was successfully created'
      redirect_to admin_partner_path partner
    else
      flash[:warning]= 'Partner was not created' #TODO: add a more graceful failure, maybe with reason
      redirect_to admin_partners_path
    end and return
  end

  def index
    @partners= Partner.all.order(@sort_sql)
    @action_item_links= [ link_to('New Partner', new_admin_partner_path) ]
  end

  def show
    @partner= Partner.find params[:id]
    @action_item_links= [ link_to('Edit Partner', edit_admin_partner_path(@partner)) ]
    if @partner.active?
      @action_item_links <<
      link_to('Upload Orphan List', upload_admin_partner_pending_orphan_lists_path(@partner))
    end
    @list= !!OrphanList.find_by(partner_id: @partner)
  end

  def new
    @partner= Partner.new
    get_form_lists
    render :new
  end

  def edit
    @partner= Partner.find params[:id]
    get_form_lists
    @edit= true
    render :edit
  end

  def update
    @partner= Partner.find params[:id]
    if @partner.update @request_params[:partner].symbolize_keys
      flash[:notice]= 'Partner was successfully updated'
      redirect_to admin_partner_path(@partner)
    else
      flash[:warning]= 'Partner was not updated'
      edit
    end and return
  end

private

=begin
  def get_form_list_for_statuses
    @form_statuses= []
    Status.all.each do |status|
      @form_statuses << {name: status.name, id: status.id}.merge(
      if @partner.id && (@partner.status.name== status.name)
        {selected: true}
      else
        {selected: false}
      end)
    end
  end

  def get_form_list_for_provinces
    @form_provinces= []
    Province.all.each do |province|
      @form_provinces << {name: province.name, id: province.id}.merge(
      if @partner.id && (@partner.province.name== province.name)
        {selected: true}
      else
        {selected: false}
      end)
    end
  end
=end
  def get_form_lists
    get_form_lists_for ['statuses', 'provinces']
  end

  def get_form_lists_for array
    array.map(&:to_s).each do |things|
      eval %{
        @form_#{things}= []
        #{things.singularize.titlecase}.all.each do |thing|
          @form_#{things} << {name: thing.name, id: thing.id}.merge(
          if @partner.id && (@partner.#{things.singularize}.name== thing.name)
            {selected: true}
          else
            {selected: false}
          end)
        end
      }
    end
  end

  def get_title
    super controller_name.singularize.titlecase
  end

end
