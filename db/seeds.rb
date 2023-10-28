# frozen_string_literal: true

require 'csv'

csv_text = File.read(Rails.root.join('db', 'transactional-sample.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')

csv.each do |row|
  Transaction.create(
    transaction_id: row['transaction_id'],
    merchant_id: row['merchant_id'],
    user_id: row['user_id'],
    card_number: row['card_number'],
    transaction_date: row['transaction_date'],
    transaction_amount: row['transaction_amount'],
    device_id: row['device_id'],
    has_cbk: row['has_cbk']
  )

  puts "Transaction_id #{row['transaction_id']} saved"
end

puts "There are now #{Transaction.count} rows in the transactions table"
