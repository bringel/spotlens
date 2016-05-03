require('rufus-scheduler')

scheduler = Rufus::Scheduler.singleton

current_user = UserAccount.where(:username => 'cafhacker').first # replace with some actual logic at some point
instagram_client = InstagramClient.new(current_user.auth_token)
hashtags = JSON.parse(ENV['hashtags'])

instagram_client.fetch_all_recent_photos(hashtags)

scheduler.every("#{ENV['photo_fetch_timer']}s") do
  current_user = UserAccount.where(:username => 'cafhacker').first # FIXME: replace with some actual logic at some point
  instagram_client = InstagramClient.new(current_user.auth_token)
  hashtags = JSON.parse(ENV['hashtags']) # get the hashtags again inside the block
  instagram_client.fetch_all_recent_photos(hashtags)

end
