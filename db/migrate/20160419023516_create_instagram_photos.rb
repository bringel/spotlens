class CreateInstagramPhotos < ActiveRecord::Migration
  def change
    create_table :instagram_photos do |t|
      t.integer :instagram_id
      t.text :photo_url
      t.text :instagram_username
      t.text :instagram_profile_photo
      t.text :instagram_fullname
      t.text :caption
      t.integer :likes
      t.datetime :post_time

      t.timestamps null: false
    end
  end
end
