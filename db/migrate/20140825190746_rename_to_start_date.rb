class RenameToStartDate < ActiveRecord::Migration
  def change
    rename_column :sponsors, :sponsorship_start_date, :start_date
    rename_column :partners, :partnership_start_date, :start_date
  end
end
