# coding: utf-8
# frozen_string_literal: true
class Payment < ActiveRecord::Base
  validates :amount, numericality: { only_integer: true }, allow_nil: false
end
