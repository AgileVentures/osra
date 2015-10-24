class RemoveOrphanStatuses < ActiveRecord::Migration
  def up
    drop_table :orphan_statuses
    drop_table :orphan_sponsorship_statuses
  end

  def down
    create_table :sponsorship_statuses do |t|
      t.integer :code
      t.string :name, index: true

      t.timestamps
    end

    create_table :orphan_statuses do |t|
      t.integer :code
      t.string :name
    end
  end
end