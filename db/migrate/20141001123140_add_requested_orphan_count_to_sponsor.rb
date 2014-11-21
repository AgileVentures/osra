class AddRequestedOrphanCountToSponsor < ActiveRecord::Migration
  def change
    add_column :sponsors, :requested_orphan_count, :integer
  end

end
