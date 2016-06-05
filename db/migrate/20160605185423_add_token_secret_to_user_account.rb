class AddTokenSecretToUserAccount < ActiveRecord::Migration
  def change
    add_column :user_accounts, :token_secret, :string
  end
end
