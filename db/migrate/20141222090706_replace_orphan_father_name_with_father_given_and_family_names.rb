class ReplaceOrphanFatherNameWithFatherGivenAndFamilyNames < ActiveRecord::Migration
  def change
    remove_column :orphans, :father_name, :string
    add_column :orphans, :father_given_name, :string, null: false
    add_column :orphans, :family_name, :string, null: false
  end
end
