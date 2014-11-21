class AddSponsorTypeToSponsor < ActiveRecord::Migration
  def change
  	    add_reference :sponsors, :sponsor_type, index: true
  end
end
