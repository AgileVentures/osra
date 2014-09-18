ActiveAdmin.register Organization do
  
  menu false

  actions :all, :except => [:destroy]

  index do 
    column :code, sortable: :code do |org|
      link_to org.code, admin_organization_path(org)
    end
    column :name, sortable: :name do |org|
      link_to org.name, admin_organization_path(org)
    end
    column :country, sortable: :country
    column :start_date, sortable: :start_date 
    column :status, sortable: :status_id
  end

  show do |org|
    attributes_table do
      row :code
      row :name
      row :country
      row :start_date
      row :status
    end
  end

  form do |f|
    f.inputs do
      f.input :code
      f.input :name
      f.input :country, :as => :string
      f.input :start_date, as: :datepicker
      f.input :status 
    end
    f.actions
  end

  permit_params :name, :country, :code, :status_id, :start_date
end
