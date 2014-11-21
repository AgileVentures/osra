class AddStatusToSponsors < ActiveRecord::Migration
  def change
    add_reference :sponsors, :status, index: true
  end
end
