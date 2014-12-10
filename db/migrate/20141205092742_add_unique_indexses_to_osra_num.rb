class AddUniqueIndexsesToOsraNum < ActiveRecord::Migration
  def change
    add_index :orphan_lists, :osra_num, unique: true
    add_index :orphans, :osra_num, unique: true
    add_index :partners, :osra_num, unique: true
    add_index :sponsors, :osra_num, unique: true
  end
end
