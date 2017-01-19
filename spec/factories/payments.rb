# coding: utf-8
# frozen_string_literal: true
FactoryGirl.define do
  factory :payment do
    amount { FactoryHelper::MySQL.integer }
  end
end
