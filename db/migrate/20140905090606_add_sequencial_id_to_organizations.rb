class AddSequencialIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :sequential_id, :integer
  end
end
