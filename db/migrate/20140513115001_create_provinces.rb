class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
