# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/transactions', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Transaction. As you add validations to Transaction, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      transaction_id: 1,
      merchant_id: 2,
      user_id: 3,
      card_number: Faker::Finance.credit_card,
      transaction_date: Time.current,
      transaction_amount: 9.99,
      device_id: 4,
      has_cbk: false
    }
  end

  let(:invalid_attributes) do
    { transaction_id: nil }
  end

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # TransactionsController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) do
    {}
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Transaction' do
        expect do
          post transactions_url,
               params: { transaction: valid_attributes }, headers: valid_headers, as: :json
        end.to change(Transaction, :count).by(1)
      end

      it 'renders a JSON response with the new transaction' do
        post transactions_url,
             params: { transaction: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Transaction' do
        expect do
          post transactions_url,
               params: { transaction: invalid_attributes }, as: :json
        end.to change(Transaction, :count).by(0)
      end

      it 'renders a JSON response with errors for the new transaction' do
        post transactions_url,
             params: { transaction: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end
end
