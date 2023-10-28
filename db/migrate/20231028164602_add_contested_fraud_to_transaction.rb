class AddContestedFraudToTransaction < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :contested_fraud, :boolean, default: false
  end
end
