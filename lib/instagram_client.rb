require('oauth2')
require('httparty')

class InstagramClient
  def initialize(token)
    @oauthToken = token
    @baseURL = "https://api.instagram.com/v1"
  end

  def mostRecentPhotosForHashtag(hashtag)
    tagURL = "#{@baseURL}/tags/#{hashtag}/media/recent?access_token=#{@oauthToken}"

    response = HTTParty.get(tagURL)
    return unless response.code >= 200 && response.code < 300


  end
end
