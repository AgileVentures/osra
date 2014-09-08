class AddStatusToOrphan < ActiveRecord::Migration
  def change
    add_reference :orphans, :orphan_status, index: true
  end
end
