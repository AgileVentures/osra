class AddIndexToOrphansPriority < ActiveRecord::Migration
  def change
    add_index :orphans, :priority
  end
end
