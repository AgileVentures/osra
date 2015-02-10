class RemoveOrphanStatuses < ActiveRecord::Migration
  def change
    drop_table :orphan_statuses
    drop_table :orphan_sponsorship_statuses
  end
end
