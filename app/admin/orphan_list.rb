ActiveAdmin.register OrphanList do
  actions :index, :new, :create

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
      link_to 'Download', download_admin_orphan_list_path(orphan_list)
    end
  end

  filter :partner
  filter :osra_num
  filter :created_at, label: 'Import Date'
  filter :orphan_count

  form do |f|
    f.inputs do
      f.input :partner
      f.input :orphan_count, as: :number
      f.input :file, as: :file
    end
    f.actions
  end

  member_action :download, method: :get do
    @orphan_list = OrphanList.find(params[:id])
    send_data(@orphan_list.file,
              type: 'application/vnd.ms-excel',
              filename: "#{@orphan_list.osra_num}.xls")
  end

  controller do
    def create
      file = params[:orphan_list].delete(:file)
      @orphan_list = OrphanList.new(orphan_list_params) do |orphan_list|
        orphan_list.file = file.read if file && is_spreadsheet?(file)
      end
      if @orphan_list.save
        redirect_to admin_orphan_list_path(@orphan_list), notice: 'Orphan List was successfully created.'
      else
        render action: :new
      end
    end

    private

    def is_spreadsheet?(file)
      ['application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'].
        include? file.content_type
    end

    def orphan_list_params
      params.require(:orphan_list).permit(:partner_id, :orphan_count)
    end
  end

  permit_params :partner_id, :orphan_count, :file
end
