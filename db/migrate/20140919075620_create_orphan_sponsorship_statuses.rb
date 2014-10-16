class CreateOrphanSponsorshipStatuses < ActiveRecord::Migration
  def change
    create_table :orphan_sponsorship_statuses do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
