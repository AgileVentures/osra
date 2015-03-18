ActiveAdmin.register Sponsor do

  filter :name, as: :string, label: "Name"
  filter :gender, as: :select, collection: Settings.lookup.gender
  filter :branch, as: :select, collection: proc { Branch.pluck(:name, :id) }
  filter :organization, as: :select, collection: proc { Organization.pluck(:name, :id) }
  filter :status, as: :select, collection: proc { Status.pluck(:name, :id) }
  filter :sponsor_type, as: :select, collection: proc { SponsorType.pluck(:name, :id) }
  filter :agent, as: :select, collection: proc { User.pluck(:user_name, :id) }
  filter :country, as: :select, collection: proc {
    Sponsor.distinct.pluck(:country).each_with_object({}) do |c, h|
      h[ISO3166::Country[c].name] = c
    end
  }
  filter :city, as: :select, collection: proc { Sponsor.distinct.pluck(:city).uniq.sort }
  filter :created_at, as: :date_range
  filter :updated_at, as: :date_range
  filter :start_date, as: :date_range
  filter :request_fulfilled, as: :boolean
  filter :active_sponsorship_count, label: "Number of active sponsorships", as: :numeric

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
    column :request_fulfilled do |sponsor|
      label = sponsor.request_fulfilled ? 'Yes' : 'No'
      label << %Q%
        (#{sponsor.active_sponsorship_count}/#{sponsor.requested_orphan_count})
      %
      status_tag(sponsor.request_fulfilled ? 'yes' : 'no', label: label)
    end
    column :sponsor_type
    column :country do |_sponsor|
      en_ar_country(_sponsor.country)
    end
  end

  show title: :name do |sponsor|
    attributes_table do
      row :name
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
      row :country do |_sponsor|
        en_ar_country(_sponsor.country)
      end
      row :city
      row :address
      row :email
      row :contact1
      row :contact2
      row :additional_info
      row :agent do
        link_to sponsor.agent.user_name, admin_user_path(sponsor.agent) if sponsor.agent
      end
      row :created_at do
        format_date(sponsor.created_at)
      end
      row :updated_at do
        format_date(sponsor.updated_at)
      end
    end

    panel "#{ pluralize(sponsor.sponsorships.all_active.count, 'Currently Sponsored Orphan') }",
                                                          id: 'currently_sponsored_orphans' do
      table_for sponsor.sponsorships.all_active do
        column :orphan
        column :orphan_date_of_birth
        column :orphan_gender
        column 'Sponsorship began' do |_sponsorship|
          format_short_date _sponsorship.start_date
        end
        column '' do |_sponsorship|
          form_submit_route= inactivate_admin_sponsor_sponsorship_path(sponsor_id: sponsor.id, id: _sponsorship.id)
          text_node ("\n" + '<form action="' + form_submit_route.to_s + '" method="post">').html_safe
            input '', type: :submit, name: :end_sponsorship, value: 'End Sponsorship'
            text_node '<label class="end_sponsorship_button_label">on:</label>'.html_safe
            input '', type: :text, name: :end_date, value: Date.current.to_s
            input '', type: :hidden, name: :_method, value: :put
            input '', type: :hidden, name: :authenticity_token, value: form_authenticity_token
          text_node '</form>'.html_safe
        end
        column '' do |_sponsorship|
          link_to 'X', admin_sponsor_sponsorship_path(sponsor_id: sponsor.id, id: _sponsorship.id), method: :delete,
            data: { confirm: 'WARNING: You are about to permanently delete the record of this sponsorship!' }
        end
      end
    end

    panel "#{ pluralize(sponsor.sponsorships.all_inactive.count,
                       'Previously Sponsored Orphan') }", id: 'previously_sponsored_orphans' do
      table_for sponsor.sponsorships.all_inactive do
        column :orphan
        column :orphan_date_of_birth
        column :orphan_gender
        column 'Sponsorship began' do |_sponsorship|
          format_short_date _sponsorship.start_date
        end
        column 'Sponsorship ended' do |_sponsorship|
          format_short_date _sponsorship.end_date
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
      f.input :payment_plan, as: :select, collection: Sponsor::PAYMENT_PLANS, include_blank: true
      f.input :country, as: :country,
              priority_countries: %w(SA TR AE GB), except: ['IL']
      f.input :city, as: :select,
              collection: Sponsor.all_cities.unshift(Sponsor::NEW_CITY_MENU_OPTION),
              include_blank: false
      f.input :new_city_name
      f.input :address
      f.input :email
      f.input :contact1
      f.input :contact2
      f.input :additional_info
    end
    f.inputs 'Assign OSRA employee' do
      f.input :agent, :as => :select, :collection => User.pluck(:user_name, :id)
    end
    f.actions do
      f.action :submit
      if f.object.new_record?
        f.action :submit, :label => 'Create and Add Another'
      end
      f.action :cancel, :label => "Cancel", :wrapper_html => { :class => "cancel" }
    end
  end

  action_item :new_sponsor, only: :show do
    link_to "New Sponsor", new_admin_sponsor_path
  end

  action_item :link_to_orphan, only: :show do
    link_to 'Link to Orphan', new_sponsorship_path(sponsor, scope: 'eligible_for_sponsorship') if sponsor.eligible_for_sponsorship?
  end

  controller do
    def create
      @sponsor = Sponsor.new(permitted_params[:sponsor])
      save_sponsor or render 'new'
    end

    private

    def save_sponsor
      if @sponsor.save
        flash[:success] = 'Sponsor was successfully created'
        redirect_to_new_or_saved_sponsor
      end
    end

    def redirect_to_new_or_saved_sponsor
      if params[:commit] == 'Create and Add Another'
        redirect_to new_admin_sponsor_path
      else
        redirect_to admin_sponsor_path @sponsor
      end
    end
  end

  permit_params :name, :country, :gender, :requested_orphan_count, :address,
                :email, :contact1, :contact2, :additional_info, :start_date,
                :status_id, :sponsor_type_id, :organization_id, :branch_id,
                :request_fulfilled, :city, :new_city_name, :agent_id,
                :payment_plan

end
