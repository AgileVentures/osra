ActiveAdmin.register PendingOrphanList do
  actions :destroy, :create
  belongs_to :partner
  menu false

  controller do
    def destroy
      pending_orphan_list = PendingOrphanList.find(params[:id])
      pending_orphan_list.destroy!
      redirect_to admin_partner_path(params[:partner_id]), alert: 'Orphan List was not imported.'
    end
  end

end
