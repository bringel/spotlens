class CreateUserAccounts < ActiveRecord::Migration
  def change
    create_table :user_accounts do |t|
      t.integer :type
      t.string :username
      t.string :fullname
      t.string :profile_picture_url
      t.string :auth_token

      t.timestamps null: false
    end
  end
end
