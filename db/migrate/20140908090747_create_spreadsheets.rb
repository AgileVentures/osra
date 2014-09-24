class CreateSpreadsheets < ActiveRecord::Migration
  def self.up
    create_table :spreadsheets do |t|
      t.integer    :orphan_list_id
      t.string     :style
      t.binary     :file_contents
    end
  end

  def self.down
    drop_table :spreadsheets
  end
end
