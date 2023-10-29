# frozen_string_literal: true

class TransactionsController < ApplicationController
  def create
    @transaction = Transaction.new(transaction_params)

    @transaction.fraud = BlackListService.new(@transaction).call || FraudScoreService.new(@transaction).call

    if @transaction.save
      response = { transaction_id: @transaction.id, recommendation: @transaction.fraud ? 'decline' : 'approve' }
      render json: response, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction)
          .permit(:transaction_id, :merchant_id, :user_id, :card_number, :transaction_date,
                  :transaction_amount, :device_id)
  end
end
