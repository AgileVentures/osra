class RemoveCompositeIndexFromSponsorships < ActiveRecord::Migration
  def change
    remove_index :sponsorships, [:sponsor_id, :orphan_id]
  end
end
