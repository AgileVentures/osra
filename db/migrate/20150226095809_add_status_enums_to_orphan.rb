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
    connection = ActiveRecord::Base.connection
    orphan_statuses = connection.execute("SELECT * FROM orphan_statuses")

    Orphan.all.each do |orphan|
      orphan_status = orphan_statuses.select {|os| os["id"] == orphan.orphan_status_id.to_s}.first
      status_code = orphan_status["code"].to_i
      orphan.update_column(:status, ( status_code - 1 ))
    end
  end

  def set_sponsorship_status
    connection = ActiveRecord::Base.connection
    orphan_sponsorship_statuses = connection.execute("SELECT * FROM orphan_sponsorship_statuses")

    Orphan.all.each do |orphan|
      orphan_sponsorship_status = orphan_sponsorship_statuses.select {|oss| oss["id"] == orphan.orphan_sponsorship_status_id.to_s}.first
      sponsorship_status_code = orphan_sponsorship_status["code"].to_i
      orphan.update_column(:sponsorship_status, ( sponsorship_status_code - 1 ))
    end
  end
end
