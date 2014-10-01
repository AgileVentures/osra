ActiveAdmin.register Sponsor do

  actions :all, except: [:destroy]

  index do
    column :osra_num, sortable: :osra_num do |sponsor|
      link_to sponsor.osra_num, admin_sponsor_path(sponsor)
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
      row :osra_num
      row :status
      row :sponsor_type
      row :country
      row :affiliate
      row :gender
      row :address
      row :email
      row :contact1
      row :contact2
      row :additional_info
      row :start_date
    end

    panel "#{ pluralize(sponsor.sponsorships.all_active.count,
                        'Currently Sponsored Orphan') }", id: 'active' do
      table_for sponsor.sponsorships.all_active do
        column :orphan
        column :orphan_date_of_birth
        column :orphan_gender
        column '' do |_sponsorship|
          link_to 'End sponsorship',
                  inactivate_admin_sponsor_sponsorship_path(sponsor_id: sponsor.id, id: _sponsorship.id),
                  method: :put
        end
      end
    end

    panel "#{ pluralize(sponsor.sponsorships.all_inactive.count,
                       'Previously Sponsored Orphan') }", id: 'inactive' do
      table_for sponsor.sponsorships.all_inactive do
        column :orphan
        column :orphan_date_of_birth
        column :orphan_gender
        column 'Sponsorship ended' do |_sponsorship|
          _sponsorship.updated_at
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
      f.input :organization
      f.input :branch
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
    link_to 'Link to Orphan', new_admin_sponsor_sponsorship_path(sponsor) if sponsor.eligible_for_sponsorship?
  end

  permit_params :name, :country, :gender, :address, :email, :contact1, :contact2, :additional_info, :start_date, :status_id, :sponsor_type_id, :organization_id, :branch_id

end
