class InstagramClient < ApiClient
  def initialize(token)
    @token = token
    @base_url = "https://api.instagram.com"
    @auth_version = :oauth2
    super()
  end

  def fetch_all_recent_photos(tags)
    tags.each do |tag|
      Rails.logger.info("fetching instagram photos for #{tag}")
      fetch_hashtag_recent_photos(tag)
    end
  end

  def fetch_hashtag_recent_photos(hashtag)
    tagURL = "/v1/tags/#{hashtag}/media/recent"

    response = @connection.get(tagURL)
    return unless response.success?

    response.body["data"].each do |photo|
      break unless photo["type"] == "image"

      caption = photo["caption"]["text"]
      likes = photo["likes"]["count"]
      username = photo["user"]["username"]
      profile_picture = photo["user"]["profile_picture"]
      fullname = photo["user"]["full_name"]
      if !photo["created_time"].empty?
        postTime = Time.at(photo["created_time"].to_i)
      end
      photoUrl = photo["images"]["standard_resolution"]["url"]
      photoID = photo["id"]

      InstagramPhoto.create({ :instagram_id => photoID, :photo_url => photoUrl, :instagram_username => username, :instagram_profile_photo => profile_picture, :instagram_fullname => fullname, :caption => caption, :likes => likes, :post_time => postTime })
    end
  end
end
