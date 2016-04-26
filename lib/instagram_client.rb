require('httparty')

class InstagramClient
  def initialize(token)
    @oauthToken = token
    @baseURL = "https://api.instagram.com/v1"
  end

  def fetch_most_recent_photos(hashtag)
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
