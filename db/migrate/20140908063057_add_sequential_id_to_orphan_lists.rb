class AddSequentialIdToOrphanLists < ActiveRecord::Migration
  def change
    add_column :orphan_lists, :sequential_id, :integer
  end
end
