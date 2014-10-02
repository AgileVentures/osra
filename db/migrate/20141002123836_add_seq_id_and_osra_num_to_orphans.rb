class AddSeqIdAndOsraNumToOrphans < ActiveRecord::Migration
  def change
    add_column :orphans, :sequential_id, :integer
    add_column :orphans, :osra_num, :string
  end
end
