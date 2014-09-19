class DropSponsorshipStatus < ActiveRecord::Migration
  def change
    drop_table :sponsorship_statuses
  end
end
