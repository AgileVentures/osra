ActiveAdmin.register OrphanList do
  form do |f|
    f.inputs do
      f.input :partner
      f.input :orphan_count, as: :number
      f.input :file, as: :file
    end
    f.actions
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
