# frozen_string_literal: true

class BlackListService
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
    percent_per_merchant || percent_per_device || percent_per_user || percent_per_card_number
  end

  private

  def percent_per_merchant
    total_transactions = Transaction.where(merchant_id: @merchant_id).count
    total_chargebacks = Transaction.where(merchant_id: @merchant_id, has_cbk: true).count

    total_chargebacks.to_f / total_transactions.to_f * 100 > CHARGEBACK_PERCENT_LIMIT_PER_MERCHANT
  end

  def percent_per_device
    total_transactions = Transaction.where(device_id: @device_id).count
    total_chargebacks = Transaction.where(device_id: @device_id, has_cbk: true).count

    total_chargebacks.to_f / total_transactions.to_f * 100 > CHARGEBACK_PERCENT_LIMIT_PER_DEVICE
  end

  def percent_per_user
    total_transactions = Transaction.where(user_id: @user_id).count
    total_chargebacks = Transaction.where(user_id: @user_id, has_cbk: true).count

    total_chargebacks.to_f / total_transactions.to_f * 100 > CHARGEBACK_PERCENT_LIMIT_PER_USER
  end

  def percent_per_card_number
    total_transactions = Transaction.where(card_number: @card_number).count
    total_chargebacks = Transaction.where(card_number: @card_number, has_cbk: true).count

    total_chargebacks.to_f / total_transactions.to_f * 100 > CHARGEBACK_PERCENT_LIMIT_PER_CARD_NUMBER
  end
end
