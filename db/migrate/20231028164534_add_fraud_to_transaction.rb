class AddFraudToTransaction < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :fraud, :boolean, default: false
  end
end
