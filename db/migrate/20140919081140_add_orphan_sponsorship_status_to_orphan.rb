class AddOrphanSponsorshipStatusToOrphan < ActiveRecord::Migration
  def change
    add_column :orphans, :orphan_sponsorship_status_id, :integer
  end
end
