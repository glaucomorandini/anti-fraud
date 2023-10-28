# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it 'is valid with valid attributes' do
    transaction = build(:transaction)
    expect(transaction).to be_valid
  end

  it 'is not valid without a transaction_id' do
    transaction = build(:transaction, transaction_id: nil)
    expect(transaction).not_to be_valid
  end

  it 'is not valid without a merchant_id' do
    transaction = build(:transaction, merchant_id: nil)
    expect(transaction).not_to be_valid
  end

  it 'is not valid without a user_id' do
    transaction = build(:transaction, user_id: nil)
    expect(transaction).not_to be_valid
  end

  it 'is not valid without a card_number' do
    transaction = build(:transaction, card_number: nil)
    expect(transaction).not_to be_valid
  end

  it 'is not valid without a transaction_date' do
    transaction = build(:transaction, transaction_date: nil)
    expect(transaction).not_to be_valid
  end

  it 'is not valid without a transaction_amount' do
    transaction = build(:transaction, transaction_amount: nil)
    expect(transaction).not_to be_valid
  end
end
