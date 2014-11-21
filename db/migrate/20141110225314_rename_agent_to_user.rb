class RenameAgentToUser < ActiveRecord::Migration
  def change
    drop_table :users
    rename_table :agents, :users
  end
end
