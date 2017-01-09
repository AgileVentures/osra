class Cashbox < ActiveRecord::Base
  has_many :deposits, class_name: 'Payment', foreign_key: 'destination_id'
  has_many :withdrawals, class_name: 'Payment', foreign_key: 'source_id'
  belongs_to :cashboxable, polymorphic: true

  def total
    deposits.sum(:amount) - withdrawals.sum(:amount)
  end

end
