class InstagramPhoto < ActiveRecord::Base
  validates(:instagram_id, {:uniqueness => true})
end
