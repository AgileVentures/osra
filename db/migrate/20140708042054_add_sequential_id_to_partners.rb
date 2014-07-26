class AddSequentialIdToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :sequential_id, :integer
  end
end
