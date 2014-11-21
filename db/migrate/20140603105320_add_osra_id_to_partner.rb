class AddOsraIdToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :osra_num, :string
  end
end
