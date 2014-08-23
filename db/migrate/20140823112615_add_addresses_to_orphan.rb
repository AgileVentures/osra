class AddAddressesToOrphan < ActiveRecord::Migration
  def change
    add_column :orphans, :original_address_id, :integer
    add_column :orphans, :current_address_id, :integer
  end
end
