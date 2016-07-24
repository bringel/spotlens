class CreateApplicationSettings < ActiveRecord::Migration
  def change
    create_table :application_settings do |t|
      t.integer :photo_fetch_timer
      t.integer :photo_switch_timer
      t.string :hashtags

      t.timestamps null: false
    end
  end
end
