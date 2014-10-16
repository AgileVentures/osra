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
  end

  show do |org|
    attributes_table do
      row :code
      row :name
    end
  end

  form do |f|
    f.inputs do
      f.input :code
      f.input :name
    end
    f.actions
  end

  permit_params :name, :code
end
