class CreateOrphanFathers < ActiveRecord::Migration
  def change
    create_table :orphan_fathers do |t|
        t.string :name
        t.string :occupation
        t.string :place_of_death
        t.string :cause_of_death
        t.boolean :is_alive?
        t.boolean :is_martyr?
        t.date :date_of_death
      t.timestamps
    end

    add_reference :orphans, :orphan_father, null: false, index: true
  end
end
