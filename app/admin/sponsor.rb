ActiveAdmin.register Sponsor do

  
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

  index do
    column :id, sortable: :id do |sponsor|
      link_to sponsor.id, admin_sponsor_path(sponsor)
    end
    column :country
    column :status
    column :sponsorship_start_date
  end

  show do |sponsor|
    attributes_table do
      row :status
      row :country
      row :address
      row :email
      row :contact1
      row :contact2
      row :additional_info
      row :sponsorship_start_date
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :country, as: :string
      f.input :address
      f.input :email
      f.input :contact1
      f.input :contact2
      f.input :additional_info
      f.input :sponsorship_start_date, as: :datepicker
      f.input :status
    end
    f.actions
  end

  permit_params :name, :country, :address, :email, :contact1, :contact2, :additional_info, :sponsorship_start_date, :status

end
