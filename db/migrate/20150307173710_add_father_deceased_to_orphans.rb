class AddFatherDeceasedToOrphans < ActiveRecord::Migration
  def up
    add_column :orphans, :father_deceased, :boolean, default: false

    convert_father_alive_to_father_deceased
  end

  def down
    remove_column :orphans, :father_deceased
  end

  private

  def convert_father_alive_to_father_deceased
    Orphan.all.each do |orphan|
      orphan.update_column(:father_deceased, !orphan.father_alive)
    end
  end
end
