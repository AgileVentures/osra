class ChangeToAdressBelongtsToOrphan < ActiveRecord::Migration
  def change
    # add type to remove column to make it a reversible migration
    remove_column :orphans, :original_address_id, :integer
    remove_column :orphans, :current_address_id, :integer
    add_column :addresses, :orphan_original_address_id, :integer
    add_column :addresses, :orphan_current_address_id, :integer
  end
end
