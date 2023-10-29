# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlackListService do
  let(:transaction) { build(:transaction) }

  describe '#call' do
    context 'when a parameter match' do
      let(:cbk_transaction) { create(:transaction, has_cbk: true) }
      let(:transaction) { build(:transaction, card_number: cbk_transaction.card_number) }

      it 'returns true' do
        expect(described_class.new(transaction).call).to eq(true)
      end
    end

    context 'when no parameter is match' do
      it 'returns false' do
        expect(described_class.new(transaction).call).to eq(false)
      end
    end
  end

  describe 'percent_per_merchant' do
    context 'when has many percent of transaction per merchant_id' do
      let(:cbk_transaction) { create(:transaction, has_cbk: true) }
      let(:transaction) { build(:transaction, merchant_id: cbk_transaction.merchant_id) }

      it 'returns true' do
        expect(described_class.new(transaction).send(:percent_per_merchant)).to eq(true)
      end
    end

    context 'when has not many percent of transaction per merchant_id' do
      it 'returns false' do
        expect(described_class.new(transaction).send(:percent_per_merchant)).to eq(false)
      end
    end
  end

  describe 'percent_per_device' do
    context 'when has many percent of transaction per device_id' do
      let(:cbk_transaction) { create(:transaction, has_cbk: true) }
      let(:transaction) { build(:transaction, device_id: cbk_transaction.device_id) }

      it 'returns true' do
        expect(described_class.new(transaction).send(:percent_per_device)).to eq(true)
      end
    end

    context 'when has not many percent of transaction per device_id' do
      it 'returns false' do
        expect(described_class.new(transaction).send(:percent_per_device)).to eq(false)
      end
    end
  end

  describe 'percent_per_user' do
    context 'when has many percent of transaction per user_id' do
      let(:cbk_transaction) { create(:transaction, has_cbk: true) }
      let(:transaction) { build(:transaction, user_id: cbk_transaction.user_id) }

      it 'returns true' do
        expect(described_class.new(transaction).send(:percent_per_user)).to eq(true)
      end
    end

    context 'when has not many percent of transaction per user_id' do
      it 'returns false' do
        expect(described_class.new(transaction).send(:percent_per_user)).to eq(false)
      end
    end
  end

  describe 'percent_per_card_number' do
    context 'when has many percent of transaction per card_number' do
      let(:cbk_transaction) { create(:transaction, has_cbk: true) }
      let(:transaction) { build(:transaction, card_number: cbk_transaction.card_number) }

      it 'returns true' do
        expect(described_class.new(transaction).send(:percent_per_card_number)).to eq(true)
      end
    end

    context 'when has not many percent of transaction per card_number' do
      it 'returns false' do
        expect(described_class.new(transaction).send(:percent_per_card_number)).to eq(false)
      end
    end
  end
end
