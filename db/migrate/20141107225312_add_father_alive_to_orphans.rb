class AddFatherAliveToOrphans < ActiveRecord::Migration
  def change
    add_column :orphans, :father_alive, :boolean
  end
end
