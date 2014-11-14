class ReplaceFatherPredicatesWithEnums < ActiveRecord::Migration
  def change
    remove_column :fathers, :is_alive?, :boolean
    remove_column :fathers, :is_martyr?, :boolean

    add_column :fathers, :status, :integer, default: 0, null: false
    add_column :fathers, :martyr_status, :integer, default: 0, null: false
  end
end
