require('rufus-scheduler')

scheduler = Rufus::Scheduler.singleton

current_instagram_user = UserAccount.where(:account_type => UserAccount.account_types[:instagram]).first
current_twitter_user = UserAccount.where(:account_type => UserAccount.account_types[:twitter]).first

if current_instagram_user
  instagram_client = InstagramClient.new(current_instagram_user.auth_token)
  hashtags = JSON.parse(ENV['hashtags'])

  instagram_client.fetch_all_recent_photos(hashtags)

  scheduler.every("#{ENV['photo_fetch_timer']}s") do
    current_instagram_user = UserAccount.where(:account_type => UserAccount.account_types[:instagram]).first
    instagram_client = InstagramClient.new(current_instagram_user.auth_token)
    hashtags = JSON.parse(ENV['hashtags']) # get the hashtags again inside the block
    instagram_client.fetch_all_recent_photos(hashtags)
  end

  if current_twitter_user
    twitter_client = TwitterClient.new(current_twitter_user.auth_token, current_twitter_user.token_secret)
    hashtags = JSON.parse(ENV['hashtags'])

    twitter_client.fetch_all_recent_photos(hashtags)

    scheduler.every("#{ENV['photo_fetch_timer']}s") do
      current_twitter_user = UserAccount.where(:account_type => UserAccount.account_types[:twitter]).first
      twitter_client = TwitterClient.new(current_twitter_user.auth_token, current_twitter_user.token_secret)
      hashtags = JSON.parse(ENV['hashtags'])
      twitter_client.fetch_all_recent_photos(hashtags)
    end
  end
end
