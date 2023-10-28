FactoryBot.define do
  factory :transaction do
    transaction_id { Faker::Number.unique.number(digits: 10) }
    merchant_id { Faker::Number.number(digits: 10) }
    user_id { Faker::Number.number(digits: 10) }
    card_number { Faker::Finance.credit_card }
    transaction_date { Faker::Time.between(from: DateTime.current - 30.minutes, to: DateTime.current) }
    transaction_amount { Faker::Commerce.price(range: 0..1000.0) }
    device_id { Faker::Number.number(digits: 10) }
    has_cbk { Faker::Boolean.boolean }
    fraud { Faker::Boolean.boolean }
    contested_fraud { Faker::Boolean.boolean }
  end
end
