class AddPaymentPlanToSponsors < ActiveRecord::Migration

  def up
    add_column :sponsors, :payment_plan, :string, { default: "", null: false }
  end
  
  def down
    remove_column :sponsors, :payment_plan
  end
  
end
