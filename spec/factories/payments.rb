# coding: utf-8
# frozen_string_literal: true
FactoryGirl.define do
  factory :payment do
    amount { FactoryHelper::MySQL.int(min: 1, max: 2147483647) }
  end
end
