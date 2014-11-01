ActiveAdmin.register Agent do

  actions :all, except: :destroy

  permit_params :first_name, :last_name, :email

  index do
    column :full_name, sortable: :last_name do |agent|
      link_to agent.full_name, admin_agent_path(agent)
    end
    column :email, sortable: :email
  end

  show do |agent|
    attributes_table do
      row :full_name
      row :email
    end

    panel "#{pluralize(agent.sponsors.count, 'Sponsor')}" do
      table_for agent.sponsors do
        column :name
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
