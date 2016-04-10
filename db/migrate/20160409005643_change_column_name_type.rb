class ChangeColumnNameType < ActiveRecord::Migration
  def change
    rename_column(:user_accounts, :type, :account_type)
  end
end
