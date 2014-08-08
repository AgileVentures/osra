class CreateSponsorTypes < ActiveRecord::Migration
  def change
    create_table :sponsor_types do |t|
      t.integer :code
      t.string :name
    end
  end
end
