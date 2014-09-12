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
  actions :all, except: [:destroy]

  index do
    column :id, sortable: :id do |sponsor|
      link_to sponsor.id, admin_sponsor_path(sponsor)
    end
    column :name, sortable: :name do |sponsor|
      link_to sponsor.name, admin_sponsor_path(sponsor)
    end
    column :sponsor_type
    column :country
    column :status, sortable: :status_id
    column :start_date
  end

  show do |sponsor|
    attributes_table do
      row :status
      row :sponsor_type
      row :country
      row :gender
      row :address
      row :email
      row :contact1
      row :contact2
      row :additional_info
      row :start_date
    end

    panel 'Sponsored Orphans' do
      table_for sponsor.orphans do
        column 'Name' do |orphan|
          link_to orphan.name, '#'
        end
        column :date_of_birth
        column :gender
        column '' do |orphan|
          link_to 'End sponsorship', '#'
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :country, as: :string
      f.input :gender, as: :select, collection: %w(Male Female)
      f.input :sponsor_type
      f.input :address
      f.input :email
      f.input :contact1
      f.input :contact2
      f.input :additional_info
      f.input :start_date, as: :datepicker
      f.input :status
    end
    f.actions
  end

  action_item only: :show do
    link_to 'Link to Orphan', '#'
  end

  permit_params :name, :country, :gender, :address, :email, :contact1, :contact2, :additional_info, :start_date, :status_id, :sponsor_type_id

end
