require 'orphan_importer'

ActiveAdmin.register PendingOrphanList do
  actions :destroy, :create, :new
  belongs_to :partner
  menu false

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :spreadsheet, as: :file
    end
    f.actions
  end

  collection_action :upload do
    get_partner
    unless @partner.active?
      flash[:alert] = 'Partner is not Active. Orphan List cannot be uploaded.'
      redirect_to admin_partner_path(params[:partner_id])
      return
    end
    render action: :upload, locals: { partner: @partner, pending_orphan_list: PendingOrphanList.new }
  end

  collection_action :validate, method: :post do
    get_partner
    unless @partner.active?
      flash[:alert] = 'Partner is not Active. Orphan List cannot be uploaded.'
      redirect_to admin_partner_path(params[:partner_id])
      return
    end
    if params['pending_orphan_list'].nil?  # no spreadsheet has been specified
      flash[:error] = 'Please specify the spreadsheet to be uploaded'
      redirect_to upload_admin_partner_pending_orphan_lists_path(params[:partner_id]) # ie same page
      return
    end
    @pending_orphan_list = PendingOrphanList.new(pending_orphan_list_params)
    importer             = OrphanImporter.new(params['pending_orphan_list']['spreadsheet'])
    result               = importer.extract_orphans
    if importer.valid?
      @pending_orphan_list.pending_orphans = result
      @pending_orphan_list.save!
      to_render = :valid_list
    else
      to_render = :invalid_list
    end
    render action: to_render,
           locals: { partner:             @partner,
                     orphan_list:         @partner.orphan_lists.build,
                     pending_orphan_list: @pending_orphan_list,
                     result:              result }
  end

  collection_action :import, method: :post do
    get_partner
    get_pending_orphan_list
    begin
      @orphan_list = @partner.orphan_lists.build(spreadsheet:  @pending_orphan_list.spreadsheet)

      @orphan_list.orphans = get_orphans_from @pending_orphan_list

      errors_list = []
      errors_list << check_for_duplicates(@orphan_list.orphans)
      errors_list << check_for_object_validity(@orphan_list.orphans)

      if errors_list.flatten.empty?
        db_persist @orphan_list.orphans
        successful_redirect
      else
        unsuccessful_redirect_and_render errors_list
      end
    rescue => e
      flash[:error] = e.message
      redirect_to admin_partner_path @partner
    ensure
      @pending_orphan_list.destroy
    end
  end

  controller do
    def destroy
      pending_orphan_list = PendingOrphanList.find(params[:id])
      pending_orphan_list.destroy!
      redirect_to admin_partner_path(params[:partner_id]), alert: 'Orphan List was not imported.'
    end

    private

    def get_partner
      @partner = Partner.find(params[:partner_id])
    end

    def pending_orphan_list_params
      params.require(:pending_orphan_list).permit(:spreadsheet)
    end

    def get_pending_orphan_list
      @pending_orphan_list = PendingOrphanList.find(params[:orphan_list][:pending_id])
    end

    def get_orphans_from(pending_orphan_list)
      orphans = []
      pending_orphan_list.pending_orphans.each do |pending_orphan|
        orphan = OrphanImporter.to_orphan pending_orphan
        orphan.assign_attributes(partner: @partner, orphan_list: @orphan_list)
        orphans << orphan
      end
      orphans
    end

    def check_for_duplicates(orphans_to_import)
      orphans_attributes = orphans_to_import.map(&:attributes)
      no_duplicates = orphans_attributes == orphans_attributes.uniq
      no_duplicates ? [] : 'File contains duplicate records.'
    end

    def check_for_object_validity(orphans_to_import)
      validation_errors = []
      orphans_to_import.each_with_index do |orphan, index|
        orphan.valid?
        orphan.errors.full_messages.each do |message|
          validation_errors << "Record ##{index+1}: #{message}"
        end
      end
      validation_errors
    end

    def db_persist(orphans_to_import)
      orphans_to_import.each(&:save!)
      @orphan_list.orphan_count = orphans_to_import.size
      @orphan_list.save!
    end

    def successful_redirect
      flash[:notice] = "Orphan List (#{@orphan_list.osra_num}) was successfully imported.
                        Registered #{@orphan_list.orphan_count} new #{'orphan'.pluralize @orphan_list.orphan_count}."
      redirect_to admin_partner_path(@partner)
    end

    def unsuccessful_redirect_and_render(errors_list)
      errors_list.unshift 'No records were imported.'
      flash[:error] = errors_list.join('<br />').html_safe
      redirect_to admin_partner_path @partner
    end
  end
end
