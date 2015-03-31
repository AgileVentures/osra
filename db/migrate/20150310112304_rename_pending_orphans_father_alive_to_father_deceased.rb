class RenamePendingOrphansFatherAliveToFatherDeceased < ActiveRecord::Migration
  def change
    rename_column :pending_orphans, :father_alive, :father_deceased
  end
end
