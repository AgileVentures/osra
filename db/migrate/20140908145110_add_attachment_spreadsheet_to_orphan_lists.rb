class AddAttachmentSpreadsheetToOrphanLists < ActiveRecord::Migration
  def self.up
    change_table :orphan_lists do |t|
      t.attachment :spreadsheet
    end
  end

  def self.down
    remove_attachment :orphan_lists, :spreadsheet
  end
end
