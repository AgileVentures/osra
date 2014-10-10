class CreatePendingOrphans < ActiveRecord::Migration
  def change
    create_table :pending_orphans do |t|
      t.references :pending_orphan_list
      t.string :name
      t.string :father_name
      t.string :father_is_martyr
      t.string :father_occupation
      t.string :father_place_of_death
      t.string :father_cause_of_death
      t.string :father_date_of_death
      t.string :mother_name
      t.string :mother_alive
      t.string :date_of_birth
      t.string :gender
      t.string :health_status
      t.string :schooling_status
      t.string :goes_to_school
      t.string :guardian_name
      t.string :guardian_relationship
      t.string :guardian_id_num
      t.string :original_address_province
      t.string :original_address_city
      t.string :original_address_neighborhood
      t.string :original_address_street
      t.string :original_address_details
      t.string :current_address_province
      t.string :current_address_city
      t.string :current_address_neighborhood
      t.string :current_address_street
      t.string :current_address_details
      t.string :contact_number
      t.string :alt_contact_number
      t.string :sponsored_by_another_org
      t.string :another_org_sponsorship_details
      t.string :minor_siblings_count
      t.string :sponsored_minor_siblings_count
      t.string :comments
    end
  end
end
