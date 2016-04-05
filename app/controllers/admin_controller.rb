require('oauth2')

class AdminController < ApplicationController
  def index

    @oauth_handler = OAuth2::Client.new("7617e91899434659a4baad896112985f", "32581f8b329f40f5827db7c218625d49", :site => "https://instagram.com")
  end

  def instagram_callback
  end
end
