class AddUniqueIndexesForPhase0 < ActiveRecord::Migration
  def change
    add_index :branches, :code, unique: true
    add_index :organizations, :name, unique: true
    add_index :organizations, :code, unique: true
    add_index :orphan_sponsorship_statuses, :name, unique: true
    add_index :orphan_sponsorship_statuses, :code, unique: true
    add_index :orphan_statuses, :name, unique: true
    add_index :orphan_statuses, :code, unique: true
    add_index :partners, :name, unique: true
    add_index :provinces, :name, unique: true
    add_index :provinces, :code, unique: true
    add_index :sponsor_types, :name, unique: true
    add_index :sponsor_types, :code, unique: true
    add_index :statuses, :name, unique: true
    add_index :statuses, :code, unique: true
  end
end
