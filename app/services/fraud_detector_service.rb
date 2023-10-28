# frozen_string_literal: true

class FraudDetectorService
  HIGH_AMOUNT_THRESHOLD = 1000.00
  SUSPICIOUS_HOURS = (0..6).to_a
  MAX_TRANSACTIONS_IN_PERIOD = 5
  MAX_AMOUNT_IN_PERIOD = 5000.00
  TIME_PERIOD = 1.hour

  HIGH_AMOUNT_THRESHOLD_POINTS = 2
  SUSPICIOUS_HOURS_POINTS = 1
  MAX_TRANSACTIONS_IN_PERIOD_POINTS = 3
  MAX_AMOUNT_IN_PERIOD_POINTS = 4
  CHARGEBACK_POINTS = 5

  FRAUD_THRESHOLD = 6

  FRAUD_RULES = {
    high_amount?: HIGH_AMOUNT_THRESHOLD_POINTS,
    suspicious_time?: SUSPICIOUS_HOURS_POINTS,
    too_many_transactions?: MAX_TRANSACTIONS_IN_PERIOD_POINTS,
    high_value_transactions?: MAX_AMOUNT_IN_PERIOD_POINTS,
    previous_chargeback?: CHARGEBACK_POINTS
  }.freeze

  def initialize(transaction)
    @transaction = transaction
    @card_number = transaction.card_number
  end

  def call
    device_id? || uncontested_fraud? || fraud_score >= FRAUD_THRESHOLD
  end

  private

  def fraud_score
    FRAUD_RULES.sum { |method, points| send(method) ? points : 0 }
  end

  def device_id?
    @transaction.device_id.blank?
  end

  def uncontested_fraud?
    Transaction.where(card_number: @card_number, fraud: true, contested_fraud: false).exists?
  end

  def high_amount?
    @transaction.transaction_amount >= HIGH_AMOUNT_THRESHOLD
  end

  def suspicious_time?
    SUSPICIOUS_HOURS.include?(@transaction.transaction_date.hour)
  end

  def too_many_transactions?
    Transaction.where(card_number: @card_number)
               .where('transaction_date > ?', TIME_PERIOD.ago)
               .count > MAX_TRANSACTIONS_IN_PERIOD
  end

  def high_value_transactions?
    Transaction.where(card_number: @card_number)
               .where('transaction_date > ?', TIME_PERIOD.ago)
               .sum(:transaction_amount) > MAX_AMOUNT_IN_PERIOD
  end

  def previous_chargeback?
    Transaction.where(card_number: @card_number, has_cbk: true).exists?
  end
end
