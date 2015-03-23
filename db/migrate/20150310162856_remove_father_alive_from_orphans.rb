class RemoveFatherAliveFromOrphans < ActiveRecord::Migration
  def change
    remove_column :orphans, :father_alive
  end
end
