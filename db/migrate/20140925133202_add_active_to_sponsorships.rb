class AddActiveToSponsorships < ActiveRecord::Migration
  def change
    add_column :sponsorships, :active, :boolean, null: false, default: true
    add_index :sponsorships, :active
  end
end
