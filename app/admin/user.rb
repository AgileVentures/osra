ActiveAdmin.register User do

  actions :all, except: :destroy

  permit_params :user_name, :email

  index do
    column :user_name, sortable: :user_name do |user|
      link_to user.user_name, admin_user_path(user)
    end
    column :email, sortable: :email
  end

  show title: :user do |user|
    attributes_table do
      row :user_name
      row :email
    end

    panel "#{pluralize(user.sponsors.count, 'Sponsor')}" do
      table_for user.sponsors do
        column :name do |sponsor|
          link_to sponsor.name, admin_sponsor_path(sponsor)
        end
        column :gender
        column :country
        column :status
        column :request_fulfilled
        column 'Orphans sponsored' do |_sponsor|
          _sponsor.orphans.count
        end
      end
    end
  end
end
