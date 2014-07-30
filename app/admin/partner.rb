ActiveAdmin.register Partner do

  
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

  show do |partner|
    attributes_table do
      row :osra_num
      row :status
      row :province
      row :region
      row :contact_details
      row :partnership_start_date
    end
  end


  permit_params :name, :region, :contact_details, :province_id, :status_id, :partnership_start_date
end
