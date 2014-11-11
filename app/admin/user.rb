ActiveAdmin.register User do

  actions :all, except: :destroy

  permit_params :user_name, :email

  index do
    column :user_name, sortable: :user_name do |user|
      link_to user.user_name, admin_user_path(user)
    end
    column :email, sortable: :email
    column 'Assigned Active Sponsors' do |_user|
      _user.active_sponsors.count
    end
  end

  show title: :user_name do |user|
    attributes_table do
      row :user_name
      row :email
    end

    panel "#{pluralize(user.sponsors.all_active.count, 'Active Sponsor')}", id: 'active_sponsors' do
      table_for user.active_sponsors do
        column :name do |sponsor|
          link_to sponsor.name, admin_sponsor_path(sponsor)
        end
        column :gender
        column :country
        column :status
        column :request_fulfilled
        column 'Orphans sponsored' do |_sponsor|
          _sponsor.currently_sponsored_orphans.count
        end
      end
    end

    panel "#{pluralize(user.sponsors.all_inactive.count, 'Inactive Sponsor')}", id: 'inactive_sponsors' do
      table_for user.inactive_sponsors do
        column :name do |sponsor|
          link_to sponsor.name, admin_sponsor_path(sponsor)
        end
        column :gender
        column :country
        column :status
        column :request_fulfilled
      end
    end
  end
end
