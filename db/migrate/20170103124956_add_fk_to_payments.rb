class AddFkToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :destination_id, :integer
    add_column :payments, :source_id, :integer

    add_index :payments, :destination_id
    add_index :payments, :source_id
  end
end
