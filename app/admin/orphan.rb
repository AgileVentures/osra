ActiveAdmin.register Orphan do

  actions :all, except: [:new, :destroy]
  filter :osra_num, as: :numeric, label: 'OSRA No.'
  filter :name
  filter :father_name
  filter :gender, as: :select, collection: Settings.lookup.gender
  filter :date_of_birth, as: :date_range
  filter :original_address_province_name, as: :select, label: 'Original address province',
          collection: -> { Province.all.order(:code).map(&:name) }
  filter :partner_name, as: :select, collection: -> { Partner.order(:name).map(&:name) }
  filter :father_is_martyr, as: :boolean

  sponsor_obj= Proc.new do |params|
    if params[:sponsor_id]
      Sponsor.find_by_id params[:sponsor_id]
    end
  end
  new_sponsorship= Proc.new do |params|
    sponsor_obj[params] && (params[:scope]== :eligible_for_sponsorship.to_s)
  end

  breadcrumb do
    [ link_to('Admin', admin_root_path) ].tap do |crumbs|
      crumbs << if sponsor_obj[params]
        [ link_to('Sponsors', admin_sponsors_path) ] <<
        link_to(sponsor_obj[params].name, admin_sponsor_path(sponsor_obj[params]))
      end << if new_sponsorship[params]
        ['Sponsorship', 'New']
      else
        ['View Orphans']
      end
    end.flatten.compact
  end

  config.sort_order= ''
  scope :all, :deep_joins, default: true, show_count: true
  scope :eligible_for_sponsorship, :sort_by_eligibility, default: false, show_count: true

  permit_params :name, :father_name, :father_is_martyr, :father_occupation,
                :father_place_of_death, :father_cause_of_death,
                :father_date_of_death, :mother_name, :mother_alive, :father_alive,
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
    f.inputs 'Parents Details' do
      f.input :father_name
      f.input :father_alive
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
      end
    end

    panel 'Parents Details' do
      attributes_table_for orphan do
        row :father_name
        row :father_alive do
          orphan.father_alive ? 'Yes' : 'No'
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
    if new_sponsorship[params]
      panel 'Sponsor' do
        h3 Sponsor.find_by_id(params[:sponsor_id]).name
        para Sponsor.find_by_id(params[:sponsor_id]).additional_info
        para link_to 'Return to Sponsor page', admin_sponsor_path(Sponsor.find_by_id(params[:sponsor_id]))
      end
      column 'OSRA No.', sortable: :osra_num do |orphan|
        link_to orphan.osra_num, admin_orphan_path(orphan)
      end
      column :name, sortable: :name do |orphan|
        link_to orphan.name, admin_orphan_path(orphan)
      end
      column :father_name, sortable: :father_name
      column :date_of_birth, sortable: :date_of_birth
      column :gender, sortable: :gender
      column :original_province, sortable: 'addresses.province_id' do |orphan|
        orphan.original_address.province.name
      end
      column :partner, sortable: 'partners.name' do |orphan|
        orphan.partner.name
      end
      column :father_is_martyr, sortable: :father_is_martyr
      column :father_alive, sortable: :father_alive
      column :mother_alive, sortable: :mother_alive
      column :priority, sortable: :priority do |orphan|
        status_tag(orphan.priority == 'High' ? 'warn' : '', label: orphan.priority)
      end
      column 'Sponsorship', sortable: 'orphan_sponsorship_statuses.name' do |orphan|
        orphan.orphan_sponsorship_status.name
      end
      column '' do |orphan| link_to "Sponsor this orphan",
            admin_sponsor_sponsorships_path(sponsor_id: params[:sponsor_id], orphan_id: orphan.id), method: :post
      end
    end

    unless new_sponsorship[params]
      column 'OSRA No.', sortable: :osra_num do |orphan|
        link_to orphan.osra_num, admin_orphan_path(orphan)
      end
      column :full_name, sortable: :name do |orphan|
        link_to orphan.full_name, admin_orphan_path(orphan)
      end
      column :date_of_birth, sortable: :date_of_birth
      column :gender, sortable: :gender
      column :orphan_status, sortable: :orphan_status_id
      column :father_alive, sortable: :father_alive
      column :mother_alive, sortable: :mother_alive
      column :priority, sortable: :priority do |orphan|
        status_tag(orphan.priority == 'High' ? 'warn' : '', label: orphan.priority)
      end
      column 'Sponsorship', sortable: 'orphan_sponsorship_status_id' do |orphan|
        orphan.orphan_sponsorship_status.name
      end
    end
  end
end
