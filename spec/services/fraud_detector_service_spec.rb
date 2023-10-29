# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FraudDetectorService do
  let(:transaction) { build(:transaction) }

  describe '#call' do
    context 'when has not a device id' do
      let(:transaction) { build(:transaction, device_id: nil) }

      it 'returns true' do
        expect(described_class.new(transaction).send(:device_id?)).to eq(true)
      end
    end

    context 'when has a device id' do
      it 'returns false' do
        expect(described_class.new(transaction).send(:device_id?)).to eq(false)
      end
    end
  end

  describe 'device_id?' do
    context 'when has not a device id' do
      let(:transaction) { build(:transaction, device_id: nil) }

      it 'returns true' do
        expect(described_class.new(transaction).send(:device_id?)).to eq(true)
      end
    end

    context 'when has a device id' do
      it 'returns false' do
        expect(described_class.new(transaction).send(:device_id?)).to eq(false)
      end
    end
  end

  describe 'uncontested_fraud?' do
    context 'when the transaction is not fraudulent and was not contested' do
      let(:unconsted_fraudulent_transaction) { create(:transaction, fraud: true, contested_fraud: false) }
      let(:transaction) { build(:transaction, card_number: unconsted_fraudulent_transaction.card_number) }

      it 'returns true' do
        expect(described_class.new(transaction).send(:uncontested_fraud?)).to eq(true)
      end
    end

    context 'when the transaction is not fraudulent and was contested' do
      let(:consted_fraudulent_transaction) { build(:transaction, fraud: true, contested_fraud: true) }
      let(:transaction) { build(:transaction, card_number: consted_fraudulent_transaction.card_number) }

      it 'returns false' do
        expect(described_class.new(transaction).send(:uncontested_fraud?)).to eq(false)
      end
    end

    context 'when the transaction is not fraudulent' do
      let(:non_fraudulent_transaction) { build(:transaction, fraud: false) }
      let(:transaction) { build(:transaction, card_number: non_fraudulent_transaction.card_number) }

      it 'returns false' do
        expect(described_class.new(transaction).send(:uncontested_fraud?)).to eq(false)
      end
    end
  end
end
