# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.bigint :transaction_id
      t.bigint :merchant_id
      t.bigint :user_id
      t.string :card_number
      t.datetime :transaction_date
      t.decimal :transaction_amount
      t.bigint :device_id
      t.boolean :has_cbk

      t.timestamps
    end
  end
end
