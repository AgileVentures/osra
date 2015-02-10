class RemoveOrphanStatusAndSponsorshipStatusFromOrphan < ActiveRecord::Migration
  def change
    remove_column :orphans, :orphan_status_id
    remove_column :orphans, :orphan_sponsorship_status_id
  end
end
