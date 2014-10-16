class RenameGuardianId < ActiveRecord::Migration
  def change
    rename_column :orphans, :guardian_id, :guardian_id_num
  end
end
