ActiveAdmin.register Partner do

  actions :all, except: [:destroy]

  index do 
    column :osra_num, sortable: :osra_num do |partner|
      link_to partner.osra_num, admin_partner_path(partner)
    end
    column :name, sortable: :name do |partner|
      link_to partner.name, admin_partner_path(partner)
    end
    column :status, sortable: :status_id
    column :province, sortable: :province_id
    column :start_date, sortable: :start_date 
  end

  show do |partner|
    attributes_table do
      row :osra_num
      row :status
      row :province
      row :region
      row :contact_details
      row :start_date
      row 'Orphan Lists' do
        link_to("Click here for all orphan lists", admin_partner_orphan_lists_path(partner))
      end
    end
  end

  form do |f|
    f.inputs do
      if !f.object.new_record?
        f.input :osra_num, :input_html => { :readonly => true }
      end
      f.input :name
      if f.object.new_record?
        f.input :province
      else
        f.input :province, :input_html => { :disabled => true }
      end
      f.input :region
      f.input :contact_details
      f.input :start_date, as: :datepicker
      f.input :status
    end
    f.actions
  end

  action_item :only => :show do
    link_to('Upload Orphan List', upload_admin_partner_orphan_lists_path(partner)) if partner.active?
  end

  permit_params :name, :region, :contact_details, :province_id, :status_id, :start_date
end
