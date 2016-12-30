# coding: utf-8
# frozen_string_literal: true

# Payment records a financial transaction.
# "amount" is in integer quantity in halalas, or hundredths of a riyal.

class Payment < ActiveRecord::Base
  validates :amount, numericality: { only_integer: true }, allow_nil: false
end
