class AddOsraNumToSponsor < ActiveRecord::Migration
  def change
    add_column :sponsors, :osra_num, :string
    add_column :sponsors, :sequential_id, :integer, :index => true
  end
end
