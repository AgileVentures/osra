class CreateOrphanLists < ActiveRecord::Migration
  def change
    create_table :orphan_lists do |t|
      t.string :osra_num
      t.belongs_to :partner, index: true
      t.integer :orphan_count
      t.binary :file

      t.timestamps
    end
  end
end
