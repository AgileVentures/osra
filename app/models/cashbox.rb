class Cashbox < ActiveRecord::Base
  has_many :deposits, class_name: 'Payment', foreign_key: 'destination_id'
  has_many :withdrawls, class_name: 'Payment', foreign_key: 'source_id'
  belongs_to :cashboxable, polymorphic: true
end
