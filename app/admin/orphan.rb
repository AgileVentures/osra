ActiveAdmin.register Orphan do

  actions :all, except: [:new, :create, :destroy]

  filter :name, as: :string
  filter :date_of_birth, as: :date_range
  filter :gender, as: :select, collection: Settings.lookup.gender
  filter :province_code, label: 'Partner Province Code', as: :select,
         collection: proc { Province.distinct.map { |p| [p.name, p.code] } }
  filter :original_address_city, label: 'Orphan City of Origin', as: :select,
        collection: proc {Orphan.distinct.pluck(:city).sort.map{|c| [c, c]} }
  filter :priority, as: :select
  filter :orphan_sponsorship_status, as: :select,
         collection: proc { OrphanSponsorshipStatus.all.map { |oss| [oss.name, oss.id] } }
  filter :orphan_status, as: :select
  filter :partner_name, as: :select, collection: -> { Partner.all_names }
  filter :father_given_name
  filter :family_name
  filter :father_is_martyr, as: :boolean
  filter :mother_alive, as: :boolean
  filter :health_status, as: :select
  filter :goes_to_school, as: :boolean
  filter :created_at, as: :date_range
  filter :updated_at, as: :date_range

  prospective_sponsor= Proc.new do |params|
    if (sponsor= Sponsor.find_by_id params[:sponsor_id])
      sponsor if sponsor.eligible_for_sponsorship?
    end
  end

  new_sponsorship= Proc.new do |params|
    prospective_sponsor[params] && (params[:scope]== 'eligible_for_sponsorship')
  end

  breadcrumb do
    [ link_to('Admin', admin_root_path, id: 'admin_root_path_crumb') ].tap do |crumbs|
      crumbs << link_to('Sponsors', admin_sponsors_path, id: 'sponsors_path_crumb') if prospective_sponsor[params]
      crumbs << link_to(prospective_sponsor[params].name, admin_sponsor_path(prospective_sponsor[params]),
              id: 'sponsor_path_crumb') if prospective_sponsor[params]
      crumbs << 'New Sponsorship' if new_sponsorship[params]
      crumbs << 'View Orphans' unless new_sponsorship[params]
    end
  end

  config.batch_actions = false
  config.sort_order= ''
  scope :all, :deep_joins, default: true, show_count: true
  scope :eligible_for_sponsorship, :sort_by_eligibility, default: false, show_count: true

  permit_params :name, :father_name, :father_given_name, :family_name, :father_is_martyr,
                :father_occupation, :father_place_of_death, :father_cause_of_death,
                :father_date_of_death, :mother_name, :mother_alive, :father_deceased,
                :date_of_birth, :gender, :health_status, :schooling_status,
                :goes_to_school, :guardian_name, :guardian_relationship,
                :guardian_id_num, :contact_number, :alt_contact_number,
                :sponsored_by_another_org, :another_org_sponsorship_details,
                :minor_siblings_count, :sponsored_minor_siblings_count,
                :comments, :orphan_status_id, :priority, :sponsor_id, :order,
                original_address_attributes: [:id, :city, :province_id,
                                              :neighborhood, :street, :details],
                current_address_attributes:  [:id, :city, :province_id,
                                              :neighborhood, :street, :details]

  form do |f|
    f.inputs 'Orphan Details' do
      f.input :osra_num, :input_html => { :readonly => true }
      f.input :name
      f.input :date_of_birth, as: :datepicker
      f.input :gender, as: :select,
              collection: Settings.lookup.gender, include_blank: false
      f.input :health_status
      f.input :schooling_status
      f.input :goes_to_school
      f.input :orphan_status, include_blank: false
      f.input :orphan_sponsorship_status, label: 'Sponsorship Status', input_html: { :disabled => true }
      f.input :priority, as: :select,
              collection: %w(Normal High), include_blank: false
    end
    f.inputs "Parents' Details" do
      f.input :father_given_name
      f.input :family_name
      f.input :father_deceased
      f.input :mother_name
      f.input :mother_alive
      f.input :father_is_martyr
      f.input :father_occupation
      f.input :father_place_of_death
      f.input :father_cause_of_death
      f.input :father_date_of_death, as: :datepicker
    end
    f.inputs 'Guardian Details' do
      f.input :guardian_name
      f.input :guardian_relationship
      f.input :guardian_id_num
      f.input :contact_number
      f.input :alt_contact_number
    end
    f.inputs 'Original Address' do
      f.semantic_fields_for :original_address do |r|
        r.inputs :city
        r.inputs :province
        r.inputs :neighborhood
        r.inputs :street
        r.inputs :details
      end
    end
    f.inputs 'Current Address' do
      f.semantic_fields_for :current_address do |r|
        r.inputs :city
        r.inputs :province
        r.inputs :neighborhood
        r.inputs :street
        r.inputs :details
      end
    end
    f.inputs 'Additional Details' do
      f.input :sponsored_by_another_org
      f.input :another_org_sponsorship_details
      f.input :minor_siblings_count
      f.input :sponsored_minor_siblings_count
      f.input :comments
    end
     f.actions do
       f.action :submit
       f.action :cancel, :label => "Cancel", :wrapper_html => { :class => "cancel" }
     end
  end
  show title: :full_name do |orphan|
    panel 'Orphan Details' do
      attributes_table_for orphan do
        row :osra_num
        row :name
        row :date_of_birth
        row :gender
        row :health_status
        row :schooling_status
        row :goes_to_school do
          orphan.goes_to_school ? 'Yes' : 'No'
        end
        row :orphan_status
        row :orphan_sponsorship_status
        row :current_sponsor if orphan.currently_sponsored?
        row :priority
        row :created_at do
              format_date(orphan.created_at)
            end
        row :updated_at do
              format_date(orphan.updated_at)
            end
      end
    end

    panel "Parents' Details" do
      attributes_table_for orphan do
        row :father_given_name
        row :family_name
        row :father_deceased do
          orphan.father_deceased ? 'Yes' : 'No'
        end
        row :mother_name
        row :mother_alive do
          orphan.mother_alive ? 'Yes' : 'No'
        end
        row :father_is_martyr do
          orphan.father_is_martyr ? 'Yes' : 'No'
        end
        row :father_occupation
        row :father_place_of_death
        row :father_cause_of_death
        row :father_date_of_death
      end
    end

    panel 'Guardian Details' do
      attributes_table_for orphan do
        row :guardian_name
        row :guardian_relationship
        row :guardian_id_num
        row :contact_number
        row :alt_contact_number
      end
    end

    panel 'Original Address' do
      attributes_table_for orphan.original_address do
        row :city
        row :province
        row :neighborhood
        row :street
        row :details
      end
    end

    panel 'Current Address' do
      attributes_table_for orphan.current_address do
        row :city
        row :province
        row :neighborhood
        row :street
        row :details
      end
    end

    panel 'Additional Details' do
      attributes_table_for orphan do
        row :sponsored_by_another_org do
          orphan.sponsored_by_another_org ? 'Yes' : 'No'
        end
        row :another_org_sponsorship_details
        row :minor_siblings_count
        row :sponsored_minor_siblings_count
        row :comments
      end
    end

  end

  index do
    class << self # instance_of ActiveAdmin::Views::IndexAsTable

      def orphan_index
        orphan_display_partial
      end

      def new_sponsorship_form_for sponsor
        form_submit_route= admin_sponsor_sponsorships_path(sponsor_id: sponsor.id).to_s
        panel 'Sponsor', id: 'new_sponsor_panel' do
          h3 sponsor.name
          para sponsor.additional_info
          para link_to 'Return to Sponsor page', admin_sponsor_path(sponsor)
        end

        orphan_display_partial

        column '' do |orphan|
          text_node ('<form action="' + form_submit_route + '" method="post">').html_safe
            input '', name: :sponsor_this_orphan, type: :submit, value: 'Sponsor this orphan'
            text_node '<label class="begin_sponsorship_button_label">beginning:</label>'.html_safe
            input '', name: :sponsorship_start_date, type: :text, value: Date.current.to_s, :class => :sponsorship_start_date_text_input
            input '', name: :orphan_id, type: :hidden, value: orphan.id.to_s
            input '', name: 'utf8', type: :hidden, value: '&#x2713;'
            input '', name: :authenticity_token, type: :hidden, value: form_authenticity_token
            input '', name: :_method, type: :hidden, value: :post
          text_node '</form>'.html_safe
        end
      end

      def orphan_display_partial
        column 'OSRA No.', sortable: :osra_num do |orphan|
          link_to orphan.osra_num, admin_orphan_path(orphan)
        end
        column :full_name, sortable: :name do |orphan| #TODO: AA removed support for multiple-column-sort, sortable: [:name, :family_name]
          link_to orphan.full_name, admin_orphan_path(orphan)
        end
        column :father_name, sortable: :father_given_name do |orphan| #TODO: AA removed support for multiple-column-sort sortable: [:father_given_name, :family_name]
          orphan.father_name
        end
        column :date_of_birth, sortable: :date_of_birth
        column :gender, sortable: :gender
        column :original_province, sortable: 'addresses.province_id' do |orphan|
          orphan.original_address.province.name
        end
        column :partner, sortable: 'partners.name' do |orphan|
          orphan.partner.name
        end
        column :father_is_martyr, sortable: :father_is_martyr
        column :father_deceased, sortable: :father_deceased
        column :mother_alive, sortable: :mother_alive
        column :priority, sortable: :priority do |orphan|
          status_tag(orphan.priority == 'High' ? 'warn' : '', label: orphan.priority)
        end
        column :orphan_status, sortable: :orphan_status_id
        column 'Sponsorship', sortable: 'orphan_sponsorship_statuses.name' do |orphan|
          orphan.orphan_sponsorship_status.name
        end
      end

    end

    unless new_sponsorship[params]
      orphan_index
    else
      new_sponsorship_form_for prospective_sponsor[params]
    end

  end

end
