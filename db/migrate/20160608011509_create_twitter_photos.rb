class CreateTwitterPhotos < ActiveRecord::Migration
  def change
    create_table :twitter_photos do |t|
      t.text :tweet_id
      t.text :photo_url
      t.text :twitter_username
      t.text :twitter_profile_photo
      t.text :twitter_fullname
      t.text :tweet_text
      t.integer :favorites
      t.integer :retweets
      t.datetime :post_time

      t.timestamps null: false
    end
  end
end
