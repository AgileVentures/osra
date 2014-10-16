class RemoveSpreadsheets < ActiveRecord::Migration
  def change
    drop_table :spreadsheets
  end
end
