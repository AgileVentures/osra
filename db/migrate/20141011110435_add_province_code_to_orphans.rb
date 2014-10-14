class AddProvinceCodeToOrphans < ActiveRecord::Migration
  def change
    add_column :orphans, :province_code, :integer, index: true
  end
end
