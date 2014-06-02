class AddStatusToPartner < ActiveRecord::Migration
  def change
    add_reference :partners, :status, index: true
  end
end
