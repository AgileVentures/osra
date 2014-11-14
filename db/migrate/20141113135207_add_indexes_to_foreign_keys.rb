class AddIndexesToForeignKeys < ActiveRecord::Migration
  def change
    add_index :partners, :sequential_id
    add_index :sponsors, :sequential_id
    add_index :orphan_lists, :sequential_id
    add_index :orphans, :orphan_sponsorship_status_id
    add_index :addresses, :province_id
    add_index :addresses, :orphan_current_address_id
    add_index :addresses, :orphan_original_address_id
    add_index :pending_orphans, :pending_orphan_list_id
  end
end
