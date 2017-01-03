class CreateCashboxes < ActiveRecord::Migration
  def change
    create_table :cashboxes do |t|
      t.integer :balance, default: 0
      t.references :cashboxable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
