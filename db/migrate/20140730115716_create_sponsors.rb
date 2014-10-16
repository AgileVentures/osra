class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|

      t.string :name
      t.string :address
      t.string :country
      t.string :email
      t.string :contact1
      t.string :contact2
      t.string :additional_info

      t.timestamps
    end
  end
end
