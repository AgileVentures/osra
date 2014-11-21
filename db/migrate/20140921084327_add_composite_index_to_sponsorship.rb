class AddCompositeIndexToSponsorship < ActiveRecord::Migration
  def change
    add_index :sponsorships, [:sponsor_id, :orphan_id], unique: true
  end
end
