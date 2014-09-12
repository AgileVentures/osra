class CreateOrphanStatuses < ActiveRecord::Migration
  def change
    create_table :orphan_statuses do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
