require('oauth2')

class AdminController < ApplicationController
  def index

    @instagram_oauth_handler = OAuth2::Client.new(ENV["INSTAGRAM_CLIENT_ID"], ENV["INSTAGRAM_CLIENT_SECRET"], :site => "https://instagram.com")

    @twitter_oauth_handler = OAuth2::Client.new(ENV["TWITTER_CLIENT_ID"], ENV["TWITTER_CLIENT_SECRET"], :site => "https://twitter.com")
  end

  def instagram_callback
  end
end
