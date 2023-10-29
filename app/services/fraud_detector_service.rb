# frozen_string_literal: true

class FraudDetectorService
  def initialize(transaction)
    @transaction = transaction
    @card_number = transaction.card_number
  end

  def call
    BlockListService.new(@transaction).call ||
      device_id? ||
      uncontested_fraud? ||
      FraudScoreService.new(@transaction).call
  end

  private

  def device_id?
    @transaction.device_id.blank?
  end

  def uncontested_fraud?
    Transaction.where(card_number: @card_number).where(fraud: true, contested_fraud: false).exists?
  end
end
