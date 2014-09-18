class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.integer :code
      t.string :name
      t.string :country
      t.date :start_date
      t.integer :status_id

      t.timestamps
    end
  end
end
