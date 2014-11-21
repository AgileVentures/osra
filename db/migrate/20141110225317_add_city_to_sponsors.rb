class AddCityToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :city, :string
  end
end
