class TwitterPhoto < ActiveRecord::Base
  validates(:tweet_id, {:uniqueness => true})
end
