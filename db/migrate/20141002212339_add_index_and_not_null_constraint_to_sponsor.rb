class AddIndexAndNotNullConstraintToSponsor < ActiveRecord::Migration
  def change
    add_index :sponsors, :request_fulfilled
    change_column :sponsors, :request_fulfilled, :boolean, :null => false
  end
end
