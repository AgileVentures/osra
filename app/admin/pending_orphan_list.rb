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
    orphan_count = 0
    orphan_list  = @partner.orphan_lists.build(spreadsheet:  @pending_orphan_list.spreadsheet,
                                               orphan_count: orphan_count)
    orphans_to_import = orphan_list.orphans

    @pending_orphan_list.pending_orphans.each do |pending_orphan|
      orphan = OrphanImporter.to_orphan pending_orphan
      orphan.partner = @partner
      orphans_to_import << orphan
    end

    errors_list = []
    if orphans_to_import.map(&:valid?).all?
      orphans_to_import.each do |orphan|
        orphan.reset_seq_id
        orphan.save!
        orphan_count += 1
      end
    else
      orphans_to_import.each_with_index do |orphan, index|
        orphan.errors.full_messages.each do |message|
          errors_list << "Record ##{index+1}: #{message}"
        end
      end
      errors_list.unshift 'Records were not imported!'
      flash[:error] = errors_list.join('<br />').html_safe
      redirect_to admin_partner_path @partner and return
    end

    orphan_list.orphan_count = orphan_count
    orphan_list.save!

    @pending_orphan_list.destroy
    flash[:notice] = "Orphan List (#{orphan_list.osra_num}) was successfully imported.
                      Registered #{orphan_count} new #{'orphan'.pluralize orphan_count}."
    redirect_to admin_partner_path(@partner)
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

  end
end
