class AddFatherAliveToPendingOrphans < ActiveRecord::Migration
  def change
    add_column :pending_orphans, :father_alive, :boolean
  end
end
