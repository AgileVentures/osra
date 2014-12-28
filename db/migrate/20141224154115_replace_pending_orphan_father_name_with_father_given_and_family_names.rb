class ReplacePendingOrphanFatherNameWithFatherGivenAndFamilyNames < ActiveRecord::Migration
  def change
    remove_column :pending_orphans, :father_name, :string
    add_column :pending_orphans, :father_given_name, :string
    add_column :pending_orphans, :family_name, :string
  end
end
