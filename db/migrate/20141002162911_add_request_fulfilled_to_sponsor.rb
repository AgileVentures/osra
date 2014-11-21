class AddRequestFulfilledToSponsor < ActiveRecord::Migration
  def change
    add_column :sponsors, :request_fulfilled, :boolean, :default => false
  end
end
