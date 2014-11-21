class AddContactDetailsToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :contact_details, :string
  end
end
