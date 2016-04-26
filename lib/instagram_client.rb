require('httparty')
require('json')
require('rufus-scheduler')

class InstagramClient
  def initialize(token)
    @oauthToken = token
    @baseURL = "https://api.instagram.com/v1"
    @scheduler = Rufus::Scheduler.new

    fetch_all_recent_photos

    @scheduler.every "#{ENV['photo_fetch_timer']}s" do
      fetch_all_recent_photos
    end
  end

  def fetch_all_recent_photos
    hashtags = JSON.parse(ENV['hashtags'])
    hashtags.each do |tag|
      fetch_hashtag_recent_photos(tag)
    end
  end

  def fetch_hashtag_recent_photos(hashtag)
    tagURL = "#{@baseURL}/tags/#{hashtag}/media/recent?access_token=#{@oauthToken}"

    response = HTTParty.get(tagURL)
    return unless response.code >= 200 && response.code < 300

    responseData = JSON.parse(response.body)
    responseData["data"].each do |photo|
      break unless photo["type"] == "image"

      caption = photo["caption"]["text"]
      likes = photo["likes"]["count"]
      username = photo["user"]["username"]
      profile_picture = photo["user"]["profile_picture"]
      fullname = photo["user"]["full_name"]
      postTime = photo["created_time"]
      photoUrl = photo["images"]["standard_resolution"]["url"]
      photoID = photo["id"]

      InstagramPhoto.create({ :instagram_id => photoID, :photo_url => photoUrl, :instagram_username => username, :instagram_profile_photo => profile_picture, :instagram_fullname => fullname, :caption => caption, :likes => likes, :post_time => postTime })
    end
  end
end
