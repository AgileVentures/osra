class RemoveSponsorshipStatusFromSponsorship < ActiveRecord::Migration
  def change
    remove_column :sponsorships, :sponsorship_status_id
  end
end
