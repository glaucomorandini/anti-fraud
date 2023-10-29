# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FraudScoreService do
  let(:transaction) { build(:transaction) }

  describe '#call' do
    context 'when exceeds the score limit' do
      let(:cbk_transaction) { create(:transaction, has_cbk: true) }
      let(:transaction) { build(:transaction, card_number: cbk_transaction.card_number, transaction_amount: 1500.00) }

      it 'returns true' do
        expect(described_class.new(transaction).call).to eq(true)
      end
    end

    context 'when does not exceeds the score limit' do
      let(:transaction) { build(:transaction, transaction_amount: 1.00, transaction_date: '2023-10-27T12:10:32.812Z') }

      it 'returns false' do
        expect(described_class.new(transaction).call).to eq(false)
      end
    end

    context 'when match some parameters but does not exceeds the score limit' do
      let(:transaction) { build(:transaction, transaction_amount: 1200.00, transaction_date: '2023-10-27T04:10:32.812Z') }

      it 'returns false' do
        expect(described_class.new(transaction).call).to eq(false)
      end
    end
  end

  describe 'high_amount?' do
    context 'when the transaction amount is above the threshold' do
      let(:transaction) { build(:transaction, transaction_amount: 1500.00) }

      it 'returns true' do
        expect(described_class.new(transaction).send(:high_amount?)).to eq(true)
      end
    end

    context 'when the transaction amount is below the threshold' do
      let(:transaction) { build(:transaction, transaction_amount: 200.00) }

      it 'returns false' do
        expect(described_class.new(transaction).send(:high_amount?)).to eq(false)
      end
    end
  end

  describe 'suspicious_time?' do
    context 'when the transaction was made at a suspicious time' do
      let(:transaction) { build(:transaction, transaction_date: '2023-10-28T04:10:32.812Z') }

      it 'returns true' do
        expect(described_class.new(transaction).send(:suspicious_time?)).to eq(true)
      end
    end

    context 'when the transaction was not made at a suspicious time' do
      let(:transaction) { build(:transaction, transaction_date: '2023-10-28T00:10:32.812Z') }

      it 'returns false' do
        expect(described_class.new(transaction).send(:suspicious_time?)).to eq(false)
      end
    end
  end

  describe 'too_many_transactions?' do
    context 'when many transactions are made in a short period of time' do
      it 'returns true' do
        FactoryBot.create_list(:transaction, 6, card_number: transaction.card_number)

        expect(described_class.new(transaction).send(:too_many_transactions?)).to eq(true)
      end
    end

    context 'when many transactions are made over different periods of time' do
      it 'returns false' do
        FactoryBot.create_list(:transaction, 6,
                               card_number: transaction.card_number,
                               transaction_date: Faker::Time.between_dates(from: Date.today - 10,
                                                                           to: Date.today - 10 - 1))

        expect(described_class.new(transaction).send(:too_many_transactions?)).to eq(false)
      end
    end
  end

  describe 'high_value_transactions?' do
    context 'when the value of transactions made in a short period of time is high' do
      it 'returns true' do
        FactoryBot.create_list(:transaction, 6, card_number: transaction.card_number, transaction_amount: 1200.00)

        expect(described_class.new(transaction).send(:high_value_transactions?)).to eq(true)
      end
    end

    context 'when the value of transactions made over different period of time is high' do
      it 'returns false' do
        FactoryBot.create_list(:transaction, 6,
                               card_number: transaction.card_number,
                               transaction_date: Faker::Time.between_dates(from: Date.today - 10,
                                                                           to: Date.today - 10 - 1))

        expect(described_class.new(transaction).send(:high_value_transactions?)).to eq(false)
      end
    end
  end

  describe 'previous_chargeback?' do
    context 'when the credit card has a previous chargeback' do
      let(:chargeback_transaction) { create(:transaction, has_cbk: true) }
      let(:transaction) { build(:transaction, card_number: chargeback_transaction.card_number) }

      it 'returns true' do
        expect(described_class.new(transaction).send(:previous_chargeback?)).to eq(true)
      end
    end

    context 'when the credit card has not a previous chargeback' do
      let(:chargeback_transaction) { create(:transaction, has_cbk: false) }
      let(:transaction) { build(:transaction, card_number: chargeback_transaction.card_number) }

      it 'returns false' do
        expect(described_class.new(transaction).send(:previous_chargeback?)).to eq(false)
      end
    end
  end

  describe 'transaction_without_device_id?' do
    context 'when has two transactions without device id' do
      it 'returns true' do
        FactoryBot.create_list(:transaction, 2, card_number: transaction.card_number, device_id: nil)

        expect(described_class.new(transaction).send(:transaction_without_device_id?)).to eq(true)
      end
    end

    context 'when has a device id' do
      it 'when has not two or more transactions without device id' do
        expect(described_class.new(transaction).send(:transaction_without_device_id?)).to eq(false)
      end
    end
  end

  describe 'days_with_same_device?' do
    context 'when there is a transaction with the same device_id for the same card for more than 75 days' do
      it 'returns true' do
        FactoryBot.create(:transaction,
                          card_number: transaction.card_number,
                          device_id: transaction.device_id,
                          transaction_date: transaction.transaction_date - 76.days)

        expect(described_class.new(transaction).send(:days_with_same_device?)).to eq(true)
      end
    end

    context 'when has a device id' do
      it 'when has not two or more transactions without device id' do
        expect(described_class.new(transaction).send(:days_with_same_device?)).to eq(false)
      end
    end
  end
end
