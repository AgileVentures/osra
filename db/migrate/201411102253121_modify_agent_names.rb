class ModifyAgentNames < ActiveRecord::Migration
  def change
    remove_column :agents, :first_name
    remove_column :agents, :last_name
    add_column :agents, :agent_name, :string
  end
end
