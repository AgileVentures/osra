class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|

      t.references :province
      t.string :city
      t.string :neighborhood
      t.string :street
      t.string :details

      t.timestamps
    end
  end
end
