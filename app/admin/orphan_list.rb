ActiveAdmin.register OrphanList do

  actions :index, :new, :create
  belongs_to :partner

  index do
    column :osra_num
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

  controller do
    def create
      @partner = Partner.find(params[:partner_id])
      @orphan_list = @partner.orphan_lists.build(orphan_list_params)
      @orphan_list.orphan_count = 0

      if @orphan_list.save
        redirect_to admin_partner_path(@partner), notice: "Orphan List (#{@orphan_list.osra_num}) was successfully imported."
      else
        render action: :new
      end
    end

    private

    def orphan_list_params
      params.require(:orphan_list).permit(:partner_id, :orphan_count, :spreadsheet)
    end
  end

  permit_params :partner_id, :orphan_count, :file
end
