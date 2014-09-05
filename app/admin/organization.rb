ActiveAdmin.register Organization do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  actions :all, :except => [:destroy]


  index do 
    column :code, sortable: :code do |org|
      link_to org.code, admin_organization_path(org)
    end
    column :name, sortable: :name do |org|
      link_to org.name, admin_organization_path(org)
    end
    column :country, sortable: :country
    column :region, sortable: :region
    column :start_date, sortable: :start_date 
    column :status, sortable: :status_id
  end

  show do |org|
    attributes_table do
      row :code
      row :name
      row :country
      row :region
      row :start_date
      row :status
    end
  end

  form do |f|
    f.inputs do
      if !f.object.new_record?
        f.input :code, :input_html => { :readonly => true }
      end
      f.input :name
      f.input :country, :as => :string
      f.input :region
      f.input :start_date, as: :datepicker
      f.input :status 
    end
    f.actions
  end

  permit_params :name, :region, :country, :code, :status_id, :start_date
end
