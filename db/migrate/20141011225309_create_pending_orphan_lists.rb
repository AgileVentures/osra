class CreatePendingOrphanLists < ActiveRecord::Migration
  def change
    create_table :pending_orphan_lists do |t|
      t.attachment :spreadsheet
      t.timestamps
    end
  end
end
