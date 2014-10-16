class AddBranchToSponsors < ActiveRecord::Migration
  def change
    add_reference :sponsors, :branch, index: true
  end
end
