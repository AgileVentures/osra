ActiveAdmin.register Sponsor do

  preserve_default_filters!
  filter :gender, as: :select, collection: Settings.lookup.gender

  actions :all, except: [:destroy]

  index do
    column :osra_num, sortable: :osra_num do |sponsor|
      link_to sponsor.osra_num, admin_sponsor_path(sponsor)
    end
    column :name, sortable: :name do |sponsor|
      link_to sponsor.name, admin_sponsor_path(sponsor)
    end
    column :status, sortable: :status_id
    column :start_date
    column :request_fulfilled
    column :sponsor_type
    column :country do |sponsor|
      ISO3166::Country.search(sponsor.country)
    end
  end

  show do |sponsor|
    attributes_table do
      row :osra_num
      row :status
      row :gender
      row :start_date
      row :requested_orphan_count
      row :request_fulfilled do
        sponsor.request_fulfilled? ? 'Yes' : 'No'
      end
      row :payment_plan
      row :sponsor_type
      row :affiliate
      row :country do
        ISO3166::Country.search(sponsor.country)
      end
      row :address
      row :email
      row :contact1
      row :contact2
      row :additional_info
      row :agent do
        link_to sponsor.agent.user_name, admin_user_path(sponsor.agent) if sponsor.agent
      end
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
      f.input :status
      f.input :gender, as: :select, collection: Settings.lookup.gender
      f.input :start_date, as: :datepicker
      f.input :requested_orphan_count
      unless f.object.new_record?
        f.input :request_fulfilled, :input_html => { :disabled => true }
      end
      if f.object.new_record?
        f.input :sponsor_type, include_blank: false
        f.input :organization
        f.input :branch
      else
        f.input :sponsor_type, :input_html => { :disabled => true }
        f.input :organization, :input_html => { :disabled => true }
        f.input :branch, :input_html => { :disabled => true }
      end
<<<<<<< HEAD
<<<<<<< HEAD
      f.input :payment_plan, as: :select, collection: Sponsor::PAYMENT_PLANS, include_blank: true 
=======
      f.input :payment_plan, as: :select, collection: ['Monthly', 'Every Two Months', 'Every Four Months', 'Every Six Months', 'Annually', 'Other']
>>>>>>> DRY up payment_plans
=======
      f.input :payment_plan, as: :select, collection: Sponsor::PAYMENT_PLANS, include_blank: false
>>>>>>> DRY out payment_plans in view
      f.input :country, as: :country, priority_countries: %w(SA TR AE GB), except: ['IL'], selected: 'SA'
      f.input :address
      f.input :email
      f.input :contact1
      f.input :contact2
      f.input :additional_info
    end
    f.inputs 'Assign OSRA employee' do
      f.input :agent, member_label: :user_name
    end
    f.actions
  end

  action_item only: :show do
    link_to 'Link to Orphan', new_admin_sponsor_sponsorship_path(sponsor) if sponsor.eligible_for_sponsorship?
  end
<<<<<<< HEAD
  
  permit_params :name, :country, :gender, :requested_orphan_count, :address, :email, :contact1, :contact2, :additional_info, :start_date, :status_id, :sponsor_type_id, :organization_id, :branch_id, :request_fulfilled, :agent_id, :payment_plan
=======

  permit_params :name, :country, :gender, :requested_orphan_count, :address, :email, :contact1, :contact2,
                :additional_info, :start_date, :status_id, :sponsor_type_id, :organization_id, :branch_id,
                :request_fulfilled, :payment_plan
>>>>>>> merge conflicts, part deux

end
