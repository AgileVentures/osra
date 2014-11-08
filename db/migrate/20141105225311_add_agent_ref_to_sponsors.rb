class AddAgentRefToSponsors < ActiveRecord::Migration
  def change
    add_reference :sponsors, :agent, index: true
  end
end
