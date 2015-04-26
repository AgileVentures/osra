class AddStatusEnumsToOrphan < ActiveRecord::Migration
  def up
    add_column :orphans, :status, :integer, default: 0
    add_column :orphans, :sponsorship_status, :integer, default: 0

    set_status
    set_sponsorship_status
  end

  def down
    remove_column :orphans, :status
    remove_column :orphans, :sponsorship_status
  end

  private

  def set_status
    Orphan.all.each do |orphan|
      status_code = orphan.orphan_status.code
      orphan.update_column(:status, ( status_code - 1 ))
    end
  end

  def set_sponsorship_status
    Orphan.all.each do |orphan|
      status_code = orphan.orphan_sponsorship_status.code
      orphan.update_column(:sponsorship_status, ( status_code - 1 ))
    end
  end
end
