ActiveAdmin.register OrphanList do

  actions :index, :new, :create
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

  collection_action :upload do
  end

  collection_action :parse, method: :post do
  end

  collection_action :import, method: :post do
  end

  controller do

    def upload
      inactive_partner_check
      @partner = partner
      render action: :upload, locals: {partner: @partner, pending_orphan_list: PendingOrphanList.new}
    end

    def parse
      inactive_partner_check
      @partner = partner

      @pending_orphan_list = PendingOrphanList.new(pending_orphan_list_params)
      render action: :upload and return unless @pending_orphan_list.valid?
      importer = OrphanImporter.new(params['pending_orphan_list']['spreadsheet'])
      importer.extract_orphans
      if importer.import_errors.empty?
        @pending_orphan_list.save!
        importer.pending_list_id = @pending_orphan_list.id
        importer.save_pending_orphans
        list_valid = true
        result = importer.pending_orphans
      else
        list_valid = false
        result = importer.import_errors
      end
      render action: :parse, locals: {partner: @partner, orphan_list: @partner.orphan_lists.build, pending_orphan_list: @pending_orphan_list, list_valid: list_valid, result: result}
    end

    def import
      @partner = partner
      @pending_orphan_list = pending_orphan_list
      @orphan_count = @pending_orphan_list.pending_orphans.count
      @pending_orphan_list.pending_orphans.each do |pending_orphan|
        (OrphanImporter.to_orphan pending_orphan).save!
      end
      @orphan_list = @partner.orphan_lists.build(spreadsheet: pending_orphan_list.spreadsheet, orphan_count: @orphan_count)
      @orphan_list.save!

      redirect_to admin_partner_path(@partner), notice: "Orphan List (#{@orphan_list.osra_num}) was successfully imported. Registered #{@orphan_list.orphan_count} #{'new orphan'.pluralize @orphan_list.orphan_count}"
    end

    def create

      @partner = partner

      @orphan_list = @partner.orphan_lists.build(orphan_list_params)
      @orphan_list.orphan_count = 0

      if @orphan_list.save
        redirect_to admin_partner_path(@partner), notice: "Orphan List (#{@orphan_list.osra_num}) was successfully imported."
      else
        render action: :new
      end
    end

    def new
      inactive_partner_check
      new!
    end

    # Workaround to prevent displaying the "Create one" link when the resource collection is empty
    # https://github.com/activeadmin/activeadmin/blob/9cfc45330e5ad31977b3ac7b2ccc1f8d6146c73f/lib/active_admin/views/pages/index.rb#L52
    def index
      params[:q] = true if collection.empty?
    end

    private

    def inactive_partner_check
      redirect_to admin_partner_path(params[:partner_id]),
                  alert: "Partner is not Active. Orphan List cannot be uploaded." and return unless partner.active?
    end

    def partner
      Partner.find(params[:partner_id])
    end

    def pending_orphan_list
      PendingOrphanList.find(params[:orphan_list][:pending_id])
    end

    def pending_orphan_list_params
      params.require(:pending_orphan_list).permit(:spreadsheet)
    end

  end
end