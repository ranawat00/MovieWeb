class AddSensitiveAttributeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :sensitive_attribute, :string
  end
end
