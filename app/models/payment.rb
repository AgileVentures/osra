# coding: utf-8
# frozen_string_literal: true

# Payment records a financial transaction.
# "amount" is in integer quantity in halalas, or hundredths of a riyal.

class Payment < ActiveRecord::Base
  belongs_to :source, class_name: 'Cashbox'
  belongs_to :destination, class_name: 'Cashbox'

  validates :amount, numericality: { only_integer: true, greater_than: 0 },
    allow_nil: false
end
