class RemoveCountryStartDateStatusIdFromOrganization < ActiveRecord::Migration
  def change
    remove_column :organizations, :status_id, :integer
    remove_column :organizations, :start_date, :date
    remove_column :organizations, :country, :string
  end
end
