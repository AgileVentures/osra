class CreateSponsorshipStatuses < ActiveRecord::Migration
  def change
    create_table :sponsorship_statuses do |t|
      t.integer :code
      t.string :name, index: true

      t.timestamps
    end
  end
end
