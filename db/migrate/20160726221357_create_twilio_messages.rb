class CreateTwilioMessages < ActiveRecord::Migration
  def change
    create_table :twilio_messages do |t|
      t.string :message_sid
      t.string :account_sid
      t.string :messaging_service_sid
      t.string :from
      t.string :to
      t.string :body
      t.integer :num_media
      t.string :media_content_type
      t.string :media_url

      t.timestamps null: false
    end
  end
end
