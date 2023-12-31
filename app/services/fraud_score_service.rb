# frozen_string_literal: true

class FraudScoreService
  HIGH_AMOUNT_THRESHOLD = 1453.57
  SUSPICIOUS_HOURS = (0..6).to_a
  MAX_TRANSACTIONS_IN_PERIOD = 5
  MAX_AMOUNT_IN_PERIOD = 5087.49
  TIME_PERIOD = 1.hour
  TRANSACTIONS_WITHOUT_DEVICE_ID = 2
  DAYS_WITH_SAME_DEVICE = 75.days

  HIGH_AMOUNT_THRESHOLD_POINTS = 3
  SUSPICIOUS_HOURS_POINTS = 3
  MAX_TRANSACTIONS_IN_PERIOD_POINTS = 4
  MAX_AMOUNT_IN_PERIOD_POINTS = 6
  TRANSACTIONS_WITHOUT_DEVICE_ID_POINTS = 2
  DAYS_WITH_SAME_DEVICE_POINTS = -2
  CHARGEBACK_POINTS = 6

  FRAUD_THRESHOLD = 6

  FRAUD_RULES = {
    high_amount?: HIGH_AMOUNT_THRESHOLD_POINTS,
    suspicious_time?: SUSPICIOUS_HOURS_POINTS,
    too_many_transactions?: MAX_TRANSACTIONS_IN_PERIOD_POINTS,
    high_value_transactions?: MAX_AMOUNT_IN_PERIOD_POINTS,
    previous_chargeback?: CHARGEBACK_POINTS,
    transaction_without_device_id?: TRANSACTIONS_WITHOUT_DEVICE_ID_POINTS,
    days_with_same_device?: DAYS_WITH_SAME_DEVICE
  }.freeze

  def initialize(transaction)
    @transaction = transaction
    @card_number = transaction.card_number
  end

  def call
    preload_transaction_data
    fraud_score >= FRAUD_THRESHOLD
  end

  private

  def cc_transactions
    @cc_transactions ||= Transaction.where(card_number: @card_number)
  end

  def preload_transaction_data
    @recent_transactions = cc_transactions.where('transaction_date > ?', TIME_PERIOD.ago)
    @total_recent_amount = @recent_transactions.sum(:transaction_amount)
    @recent_transactions_count = @recent_transactions.count
    @device_id_transactions_count = cc_transactions.where(device_id: nil).count
    @old_device_transactions_exists = cc_transactions.where(device_id: @transaction.device_id)
                                                     .where('transaction_date < ?', DAYS_WITH_SAME_DEVICE.ago)
                                                     .exists?
  end

  def fraud_score
    FRAUD_RULES.sum { |method, points| send(method) ? points : 0 }
  end

  def high_amount?
    @transaction.transaction_amount >= HIGH_AMOUNT_THRESHOLD
  end

  def suspicious_time?
    SUSPICIOUS_HOURS.include?(@transaction.transaction_date.hour)
  end

  def too_many_transactions?
    @recent_transactions_count > MAX_TRANSACTIONS_IN_PERIOD
  end

  def high_value_transactions?
    @total_recent_amount > MAX_AMOUNT_IN_PERIOD
  end

  def previous_chargeback?
    Transaction.where(card_number: @card_number, has_cbk: true).exists?
  end

  def transaction_without_device_id?
    @device_id_transactions_count >= TRANSACTIONS_WITHOUT_DEVICE_ID
  end

  def days_with_same_device?
    @old_device_transactions_exists
  end
end
