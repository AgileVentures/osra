class ChangeOrphanFatherAssociation < ActiveRecord::Migration
  def change
    remove_column :orphans, :father_id, :integer

    add_column :fathers, :orphan_id, :integer
  end
end
