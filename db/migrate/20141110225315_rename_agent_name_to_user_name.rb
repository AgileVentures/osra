class RenameAgentNameToUserName < ActiveRecord::Migration
  def change
    rename_column :users, :agent_name, :user_name
  end
end
