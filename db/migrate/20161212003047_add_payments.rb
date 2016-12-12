# coding: utf-8
# frozen_string_literal: true
class AddPayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount, null: false
      t.timestamps null: false
    end
  end
end
