class AddPriorityToOrphans < ActiveRecord::Migration
  def change
    add_column :orphans, :priority, :string
  end
end
