ActiveAdmin.register OrphanList do

  actions :index
  belongs_to :partner

  config.clear_action_items!

  index do
    column :osra_num
    column :spreadsheet_file_name
    column :partner, sortable: :partner_id do |orphan_list|
      link_to orphan_list.partner.name, admin_partner_path(orphan_list.partner)
    end
    column :import_date, sortable: :created_at do |orphan_list|
      orphan_list.created_at.to_date
    end
    column :orphan_count
    column do |orphan_list|
      link_to 'Download', orphan_list.spreadsheet.url
    end
  end

  filter :partner
  filter :osra_num
  filter :created_at, label: 'Import Date'
  filter :orphan_count

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :spreadsheet, as: :file
    end
    f.actions
  end

  collection_action :upload

  collection_action :validate, method: :post

  collection_action :import, method: :post

  controller do

    def upload
      redirect_to admin_partner_path(params[:partner_id]),
                  alert: "Partner is not Active. Orphan List cannot be uploaded." and return unless partner.active?
      @partner = partner
      render action: :upload, locals: { partner: @partner, pending_orphan_list: PendingOrphanList.new }
    end

    def validate
      redirect_to admin_partner_path(params[:partner_id]),
                  alert: "Partner is not Active. Orphan List cannot be uploaded." and return unless partner.active?
      @partner = partner
      @pending_orphan_list = PendingOrphanList.new(pending_orphan_list_params)
      @pending_orphan_list.save!
      filename = params['pending_orphan_list']['spreadsheet'].original_filename

      # This is just a place holder until the importer code is merged
      list_valid = !(filename.include? 'empty' or filename.include? 'invalid')

      render action: :validate, locals: { partner: @partner, orphan_list: @partner.orphan_lists.build, pending_orphan_list: @pending_orphan_list, list_valid: list_valid }
    end

    def import
      @partner = partner
      @pending_orphan_list = pending_orphan_list
      @orphan_count = 0
      @orphan_list = @partner.orphan_lists.build(spreadsheet: pending_orphan_list.spreadsheet, orphan_count: @orphan_count)
      @orphan_list.save!
      @pending_orphan_list.destroy
      redirect_to admin_partner_path(@partner), notice: 'Orphan List was successfully imported.'
    end

    # Workaround to prevent displaying the "Create one" link when the resource collection is empty
    # https://github.com/activeadmin/activeadmin/blob/9cfc45330e5ad31977b3ac7b2ccc1f8d6146c73f/lib/active_admin/views/pages/index.rb#L52
    def index
      params[:q] = true if collection.empty?
    end

    private

    def partner
      Partner.find(params[:partner_id])
    end

    def orphan_list_params
      params.require(:orphan_list).permit(:spreadsheet)
    end

    def pending_orphan_list_params
      params.require(:pending_orphan_list).permit(:spreadsheet)
    end

    def pending_orphan_list
      PendingOrphanList.find(params[:orphan_list][:pending_id])
    end

  end
end