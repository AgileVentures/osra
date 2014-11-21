class AddIndexToOrphansOnSequentialId < ActiveRecord::Migration
  def change
    add_index :orphans, :sequential_id
  end
end
