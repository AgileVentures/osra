class AddSponsorshipStartDateToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :sponsorship_start_date, :date
  end
end
