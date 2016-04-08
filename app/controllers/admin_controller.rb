require('oauth2')
require('byebug')
class AdminController < ApplicationController
  def index
    instagram_oauth_handler = OAuth2::Client.new(ENV['INSTAGRAM_CLIENT_ID'], ENV['INSTAGRAM_CLIENT_SECRET'], :site => "https://api.instagram.com")
    @instagram_oauth_code_link = instagram_oauth_handler.auth_code.authorize_url(:redirect_uri => instagram_callback_url, :scope => "public_content")

    @twitter_oauth_handler = OAuth2::Client.new(ENV['TWITTER_CLIENT_ID'], ENV['TWITTER_CLIENT_SECRET'], :site => "https://twitter.com")
    @twitter_oauth_code_link = @twitter_oauth_handler.auth_code.authorize_url(:redirect_url => twitter_callback_url)
  end

  def instagram_callback
    instagram_oauth_handler = OAuth2::Client.new(ENV['INSTAGRAM_CLIENT_ID'], ENV['INSTAGRAM_CLIENT_SECRET'], :site => "https://api.instagram.com", :token_url => "/oauth/access_token")

    @token = instagram_oauth_handler.auth_code.get_token(params[:code], :redirect_uri => "#{request.protocol}#{request.host}#{request.port_string}/admin/instagram_callback")
    redirect_to action: "index"
  end

  def twitter_callback
  end

  def instagram_callback_url
    "#{request.protocol}#{request.host_with_port}/admin/instagram_callback"
  end

  def twitter_callback_url
    "#{request.protocol}#{request.host_with_port}/admin/twitter_callback"
  end
end
