class AddOrganizationToSponsors < ActiveRecord::Migration
  def change
    add_reference :sponsors, :organization, index: true
  end
end
