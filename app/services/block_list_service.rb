# frozen_string_literal: true

class BlockListService
  CHARGEBACK_PERCENT_LIMIT_PER_MERCHANT = 10
  CHARGEBACK_PERCENT_LIMIT_PER_DEVICE = 10
  CHARGEBACK_PERCENT_LIMIT_PER_USER = 10
  CHARGEBACK_PERCENT_LIMIT_PER_CARD_NUMBER = 10

  def initialize(transaction)
    @transaction = transaction
    @merchant_id = transaction.merchant_id
    @device_id = transaction.device_id
    @user_id = transaction.user_id
    @card_number = transaction.card_number
  end

  def call
    percent_per_merchant? || percent_per_device? || percent_per_user? || percent_per_card_number?
  end

  private

  def percent_per_merchant?
    transactions = Transaction.where(merchant_id: @merchant_id)

    percent_cbk(transactions) > CHARGEBACK_PERCENT_LIMIT_PER_MERCHANT
  end

  def percent_per_device?
    transactions = Transaction.where(device_id: @device_id)

    percent_cbk(transactions) > CHARGEBACK_PERCENT_LIMIT_PER_DEVICE
  end

  def percent_per_user?
    transactions = Transaction.where(user_id: @user_id)

    percent_cbk(transactions) > CHARGEBACK_PERCENT_LIMIT_PER_USER
  end

  def percent_per_card_number?
    transactions = Transaction.where(card_number: @card_number)

    percent_cbk(transactions) > CHARGEBACK_PERCENT_LIMIT_PER_CARD_NUMBER
  end

  def percent_cbk(transactions)
    total_chargebacks(transactions).to_f / total_transactions(transactions) * 100
  end

  def total_transactions(transactions)
    transactions.count
  end

  def total_chargebacks(transactions)
    transactions.where(has_cbk: true).count
  end
end
