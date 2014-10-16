class AddPartnershipStartDateToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :partnership_start_date, :date
  end
end
