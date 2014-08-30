class CreateOrphans < ActiveRecord::Migration
  def change
    create_table :orphans do |t|

      t.string :name
      t.string :father_name
      t.boolean :father_is_martyr
      t.string :father_occupation
      t.string :father_place_of_death
      t.string :father_cause_of_death
      t.date :father_date_of_death
      t.string :mother_name
      t.boolean :mother_alive
      t.date :date_of_birth
      t.string :gender
      t.string :health_status
      t.string :schooling_status
      t.boolean :goes_to_school
      t.string :guardian_name
      t.string :guardian_relationship
      t.integer :guardian_id
      t.string :contact_number
      t.string :alt_contact_number
      t.boolean :sponsored_by_another_org
      t.string :another_org_sponsorship_details
      t.integer :minor_siblings_count
      t.integer :sponsored_minor_siblings_count
      t.string :comments

      t.timestamps
    end
  end
end
