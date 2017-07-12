class AssociatePartnersAndOrphansDirectly < ActiveRecord::Migration
  def up
    add_reference :orphans, :partner, index: true, foreign_key: true

    Orphan.reset_column_information
    orphans = Orphan.all
    orphans.each do |orphan|
      orphan.update(partner_id: orphan.orphan_list.partner.id)
    end
  end

  def down
    remove_reference :orphans, :partner, index: true, foreign_key: true
  end
end
