class CreateStatus < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :code
      t.string :name
    end
  end
end
