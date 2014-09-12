class CreateSponsorshipStatuses < ActiveRecord::Migration
  def change
    create_table :sponsorship_statuses do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
