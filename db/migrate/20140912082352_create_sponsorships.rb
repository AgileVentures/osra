class CreateSponsorships < ActiveRecord::Migration
  def change
    create_table :sponsorships do |t|
      t.references :sponsor, index: true
      t.references :orphan, index: true
      t.references :sponsorship_status, index: true

      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
