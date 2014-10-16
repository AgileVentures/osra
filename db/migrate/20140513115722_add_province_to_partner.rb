class AddProvinceToPartner < ActiveRecord::Migration
  def change
    add_reference :partners, :province, index: true
  end
end
