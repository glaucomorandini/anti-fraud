# frozen_string_literal: true

class Transaction < ApplicationRecord
  validates :transaction_id, presence: true
  validates :merchant_id, presence: true
  validates :user_id, presence: true
  validates :card_number, presence: true
  validates :transaction_date, presence: true
  validates :transaction_amount, presence: true
end
