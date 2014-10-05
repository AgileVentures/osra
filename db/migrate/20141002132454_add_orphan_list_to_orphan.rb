class AddOrphanListToOrphan < ActiveRecord::Migration
  def change
    add_reference :orphans, :orphan_list, index: true
  end
end
