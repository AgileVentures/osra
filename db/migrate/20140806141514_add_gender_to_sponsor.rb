class AddGenderToSponsor < ActiveRecord::Migration
  def change
    add_column :sponsors, :gender, :string
  end
end
